# Course Data Generation Scripts

## Overview

This directory contains scripts for fetching course data from SFU's REST API and loading it into the database.

## Files

### `generate_course.rb`
Main script that fetches course data from SFU's course outline API. It can operate in two modes:
- **File mode (default)**: Generates seed files in `course_seed_data/` directory
- **Database mode**: Directly loads courses into the database

### `prerequisite_parser.rb`
Robust rule-based parser for converting prerequisite text descriptions into structured logical expressions. No longer uses Groq API.

## Usage

### Generate Seed Files (Default)
```bash
cd lib/scripts
ruby generate_course.rb
```

### Load Directly to Database
```bash
cd lib/scripts
LOAD_TO_DB=true ruby generate_course.rb
# OR
ruby generate_course.rb --load-to-db
```

## Prerequisite Parser

The new prerequisite parser is a rule-based system that handles:

### Supported Patterns
- **Course codes with grades**: "CHEM 122 with a minimum grade of C-"
- **OR groups**: "MATH 232 or MATH 240"
- **One of patterns**: "one of CMPT 102, 120, 126, 128 or 130"
- **Nested structures**: "MACM 101 or (ENSC 251 and one of MATH 232 or MATH 240)"
- **Credit requirements**: "minimum of 45 credits", "completion of 60 units"
- **GPA/CGPA requirements**: "minimum CGPA 2.67", "GPA 2.75"
- **W course requirements**: "one W course"

### Output Format
The parser generates logical expressions in the format expected by the Course model:
- `(CMPT 225 >= C- AND MATH 154 >= B+ AND CGPA >= 2.50)`
- `(CREDITS >= 60 AND CMPT 125 >= C-)`
- `(MATH 232 >= C- OR MATH 240 >= C-)`
- `#no_prereq_logic` for courses with no prerequisites

### Ignored Content
The parser automatically ignores:
- High school courses (BC MATH 12, etc.)
- Permission requirements
- Recommendations
- Co-requisites
- Non-course-specific instructions

## Database Loading

When loading directly to the database:
- Validates all required fields
- Handles duplicate courses (updates existing)
- Provides detailed error messages
- Escapes strings properly for database insertion

## Configuration

Edit the script to modify:
- `year_scope`: Years to fetch (default: ["2022", "2023", "2024", "2025"])
- `terms`: Terms to fetch (default: ["fall", "spring", "summer"])
- `departments`: Department codes to fetch

## Error Handling

The script includes:
- Retry logic for API calls (exponential backoff)
- Timeout handling
- JSON parsing error handling
- Database validation errors
- Detailed logging of successes and failures
