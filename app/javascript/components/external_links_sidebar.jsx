import React, { useState } from 'react';
import "./external_links_sidebar.css";

const facultyStructure = {
    "Beedie School of Business": {
            "Majors": [
                { name: "Business Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business/major/bachelor-of-business-administration.html"},
                { name: "Mechatronic Systems Engineering and Business Double Degree Program Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mechatronic-systems-engineering-and-business-double-degree-program/major/bachelor-of-applied-science-and-bachelor-of-business-administration.html"},
            ],
            "Honours": [
                { name: "Business Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business/honours/bachelor-of-business-administration.html"},
            ],
            "Joint Majors": [
                { name: "Business and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-communication/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Business and Economics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-economics/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Business and Psychology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-psychology/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Business, Philosophy and the Law Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-philosophy-and-the-law/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Geo Business Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geo-business/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Information Systems in Business Administration and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/information-systems-in-business-administration-and-computing-science/joint-major/bachelor-of-business-administration-or-bachelor-of-science.html"},
                { name: "Interactive Arts and Technology and Business Joint Major (BA or BBA)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/interactive-arts-and-technology-and-business/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Interactive Arts and Technology and Business Joint Major (BSc)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/interactive-arts-and-technology-and-business/joint-major/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Business Administration Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-business-administration/joint-major/bachelor-of-science.html"},
                { name: "Sustainable Business Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sustainable-business/joint-major/bachelor-of-business-administration-or-bachelor-of-environment.html"},
            ],
            "Joint Honours": [
                { name: "Business and Economics Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-economics/joint-honours/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Molecular Biology and Biochemistry and Business Administration Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-business-administration/joint-honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Business Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business/minor.html"},
            ],
    },

    "Faculty of Applied Sciences": {
        "School of Computing Science": {
            "Majors": [
                { name: "Computing Science Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science/major/bachelor-of-science-or-bachelor-of-arts.html"},
                { name: "Computing Science Dual Degree Program Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science-dual-degree-program/major/bachelor-of-science.html"},
                { name: "Computing Science Second Degree Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science-second-degree/major/bachelor-of-science-or-bachelor-of-arts.html"},
                { name: "Software Systems Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/software-systems/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Computing Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science/honours/bachelor-of-science-or-bachelor-of-arts.html"},
                { name: "Geographic Information Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geographic-information-science/honours/bachelor-of-science.html"},
                { name: "Computing Science and Linguistics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science-and-linguistics/joint-major/bachelor-of-arts-or-bachelor-of-science.html"},
                { name: "Information Systems in Business Administration and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/information-systems-in-business-administration-and-computing-science/joint-major/bachelor-of-business-administration-or-bachelor-of-science.html"},
                { name: "Mathematics and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics-and-computing-science/joint-major/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-computing-science/joint-major/bachelor-of-science.html"},
                { name: "Mathematics and Computing Science Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics-and-computing-science/joint-honours/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Computing Science Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-computing-science/joint-honours/bachelor-of-science.html"},
                { name: "Computing Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science/minor.html"},
            ],
            "Joint Majors": [
                { name: "Computing Science and Linguistics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science-and-linguistics/joint-major/bachelor-of-arts-or-bachelor-of-science.html"},
                { name: "Information Systems in Business Administration and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/information-systems-in-business-administration-and-computing-science/joint-major/bachelor-of-business-administration-or-bachelor-of-science.html"},
                { name: "Mathematics and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics-and-computing-science/joint-major/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-computing-science/joint-major/bachelor-of-science.html"},
                { name: "Mathematics and Computing Science Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics-and-computing-science/joint-honours/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Computing Science Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-computing-science/joint-honours/bachelor-of-science.html"},
                { name: "Computing Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science/minor.html"},
            ],
            "Joint Honours": [
                { name: "Mathematics and Computing Science Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics-and-computing-science/joint-honours/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Computing Science Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-computing-science/joint-honours/bachelor-of-science.html"},
                { name: "Computing Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science/minor.html"},
            ],
            "Minors": [
                { name: "Computing Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science/minor.html"},
            ],
        },
        "School of Engineering Science": {
            "Majors": [
                { name: "Engineering Science, Biomedical Engineering Option Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-biomedical-engineering-option/major/bachelor-of-applied-science.html"},
                { name: "Engineering Science, Computer Engineering Option Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-computer-engineering-option/major/bachelor-of-applied-science.html"},
                { name: "Engineering Science, Electronics Engineering Option Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-electronics-engineering-option/major/bachelor-of-applied-science.html"},
                { name: "Engineering Science, Systems Engineering Option Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-systems-engineering-option/major/bachelor-of-applied-science.html"},
            ],
            "Honours": [
                { name: "Engineering Science, Biomedical Engineering Option Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-biomedical-engineering-option/honours/bachelor-of-applied-science.html"},
                { name: "Engineering Science, Computer Engineering Option Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-computer-engineering-option/honours/bachelor-of-applied-science.html"},
                { name: "Engineering Science, Electronics Engineering Option Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-electronics-engineering-option/honours/bachelor-of-applied-science.html"},
                { name: "Engineering Science, Engineering Physics Option Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-engineering-physics-option/honours/bachelor-of-applied-science.html"},
                { name: "Engineering Science, Systems Engineering Option Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/engineering-science-systems-engineering-option/honours/bachelor-of-applied-science.html"},

            ],
            "Minors": [
                { name: "Computer and Electronics Design Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computer-and-electronics-design/minor.html"},
            ],
        },
        "School of Mechatronic Systems Engineering": {
            "Majors": [
                { name: "Mechatronic Systems Engineering Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mechatronic-systems-engineering/major/bachelor-of-applied-science.html"},
                { name: "Mechatronic Systems Engineering and Business Double Degree Program Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mechatronic-systems-engineering-and-business-double-degree-program/major/bachelor-of-applied-science-and-bachelor-of-business-administration.html"},
            ],
            "Honours": [
                { name: "Mechatronic Systems Engineering Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mechatronic-systems-engineering/honours/bachelor-of-applied-science.html"},
            ],
        },
        "School of Sustainable Energy Engineering": {
            "Majors": [
                { name: "Sustainable Energy Engineering Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sustainable-energy-engineering/major/bachelor-of-applied-science.html"},
            ],
            "Honours": [
                { name: "Sustainable Energy Engineering Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sustainable-energy-engineering/honours/bachelor-of-applied-science.html"},
            ]
        },
    },

    "Faculty of Arts and Social Sciences": {
        "Cognitive Science Program": {
            "Majors": [
                { name: "Cognitive Science Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/cognitive-science/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Cognitive Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/cognitive-science/honours/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Cognitive Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/cognitive-science/minor.html"},
            ],
        },
        "Department of Economics": {
            "Majors": [
                { name: "Economics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/economics/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Economics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/economics/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Business and Economics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-economics/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Political Science and Economics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science-and-economics/joint-major/bachelor-of-arts.html"},
            ],
            "Joint Honours": [
                { name: "Business and Economics Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-economics/joint-honours/bachelor-of-arts-or-bachelor-of-business-administration.html"},
            ],
            "Minors": [
                { name: "Economics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/economics/minor.html"},
                { name: "Economics Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/economics/extended-minor.html"},
                { name: "Social Data Analytics Minor", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/social-data-analytics/minor.html"}
            ],
        },
        "Department of English": {
            "Majors": [
                { name: "English Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "English Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "English and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-communication/joint-major/bachelor-of-arts.html"},
                { name: "English and French Literatures Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-french-literatures/joint-major/bachelor-of-arts.html"},
                { name: "English and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "English and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-global-humanities/joint-major/bachelor-of-arts.html"},
                { name: "English and History Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-history/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Creative Writing Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/creative-writing/minor.html"},
                { name: "English Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english/minor.html"},
                { name: "English Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english/extended-minor.html"},
            ]
        },
        "Department of French": {
            "Majors": [
                { name: "French and Francophone Studies Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-and-francophone-studies/major/bachelor-of-arts.html"},
                { name: "French Cohort Program in Public and International Affairs Political Science Major with a French and Francophone Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-cohort-program-in-public-and-international-affairs-political-science-major-with-a-french-and-francophone-studies-minor/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "French Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "English and French Literatures Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-french-literatures/joint-major/bachelor-of-arts.html"},
                { name: "French and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-and-global-humanities/joint-major/bachelor-of-arts.html"},
                { name: "French, History and Politics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-history-and-politics/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "French and Francophone Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-and-francophone-studies/minor.html"},
                { name: "French Studies Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-studies/extended-minor.html"},
                { name: "French Education Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-education/minor.html"},
            ],
        },
        "Department of Gender, Sexuality, and Women's Studies": {
            "Majors": [
                { name: "Gender, Sexuality, and Women's Studies Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/gender-sexuality-and-women-s-studies/major/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Anthropology and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "Criminology and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "English and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "Gender, Sexuality, and Women's Studies and Psychology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/gender-sexuality-and-women-s-studies-and-psychology/joint-major/bachelor-of-arts.html"},
                { name: "Global Humanities and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/global-humanities-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "History and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "Political Science and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "Sociology and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Gender, Sexuality, and Women's Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/gender-sexuality-and-women-s-studies/minor.html"},
                { name: "Gender, Sexuality, and Women's Studies Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/gender-sexuality-and-women-s-studies/extended-minor.html"},
            ],
        },
        "Department of Gerontology": {
            "Minors": [
                { name: "Gerontology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/gerontology/minor.html"},
            ],
        },
        "Department of Global Humanities": {
            "Majors": [
                { name: "Global Humanities Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/global-humanities/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Humanities Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/humanities/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "English and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-global-humanities/joint-major/bachelor-of-arts.html"},
                { name: "French and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-and-global-humanities/joint-major/bachelor-of-arts.html"},
                { name: "Global Humanities and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/global-humanities-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "History and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history-and-global-humanities/joint-major/bachelor-of-arts.html"},
                { name: "Philosophy and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy-and-global-humanities/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Global Humanities Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/global-humanities/minor.html"},
                { name: "Global Humanities Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/global-humanities/extended-minor.html"},
            ],
        },
        "Department of History": {
            "Majors": [
                { name: "History Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "History Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "English and History Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-history/joint-major/bachelor-of-arts.html"},
                { name: "French, History and Politics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-history-and-politics/joint-major/bachelor-of-arts.html"},
                { name: "History and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "History and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history-and-global-humanities/joint-major/bachelor-of-arts.html"},
                { name: "World Literature and History Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature-and-history/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "History Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history/minor.html"},
                { name: "History Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/history/extended-minor.html"},
            ],
        },
        "Department of Indigenous Studies": {
            "Majors": [
                { name: "Indigenous Studies Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/indigenous-studies/major/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Archaeology and Indigenous Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/archaeology-and-indigenous-studies/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Indigenous Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/indigenous-studies/minor.html"},
            ]
        },
        "Department of Linguistics": {
            "Majors": [
                { name: "Linguistics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/linguistics/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Linguistics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/linguistics/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Computing Science and Linguistics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/computing-science-and-linguistics/joint-major/bachelor-of-arts-or-bachelor-of-science.html"},
                { name: "Linguistics and Anthropology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/linguistics-and-anthropology/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Indigenous Languages Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/indigenous-languages/minor.html"},
                { name: "Linguistics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/linguistics/minor.html"},
                { name: "Social Data Analytics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/social-data-analytics/minor.html"},
                { name: "Linguistics Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/linguistics/extended-minor.html"},
                { name: "Social Data Analytics Minor", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/social-data-analytics/minor.html"},
            ],
        },
        "Department of Sociology and Anthropology": {
            "Majors": [
                { name: "Anthropology Major", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/african-studies/certificate.html"},
                { name: "Sociology Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Anthropology Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology/honours/bachelor-of-arts.html"},
                { name: "Sociology Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Anthropology and Archaeology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-archaeology/joint-major/bachelor-of-arts.html"},
                { name: "Anthropology and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-communication/joint-major/bachelor-of-arts.html"},
                { name: "Anthropology and Criminology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-criminology/joint-major/bachelor-of-arts.html"},
                { name: "Anthropology and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "Anthropology and Sociology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-sociology/joint-major/bachelor-of-arts.html"},
                { name: "Linguistics and Anthropology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/linguistics-and-anthropology/joint-major/bachelor-of-arts.html"},
                { name: "Anthropology and Sociology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-sociology/joint-major/bachelor-of-arts.html"},
                { name: "Sociology and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology-and-communication/joint-major/bachelor-of-arts.html"},
                { name: "Sociology and Criminology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology-and-criminology/joint-major/bachelor-of-arts.html"},
                { name: "Sociology and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
            ],
            "Joint Honours": [
                { name: "Sociology and Anthropology Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology-and-anthropology/joint-honours/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Anthropology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology/minor.html"},
                { name: "Anthropology Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology/extended-minor.html"},
                { name: "Sociology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology/minor.html"},
                { name: "Sociology Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology/extended-minor.html"},
            ],
        },
        "Department of Philosophy": {
            "Majors": [
                { name: "Philosophy Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Philosophy Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Business, Philosophy and the Law Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-philosophy-and-the-law/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Philosophy and Global Humanities Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy-and-global-humanities/joint-major/bachelor-of-arts.html"},
                { name: "Philosophy and Health Sciences Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy-and-health-sciences/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [         
                { name: "Philosophy Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy/minor.html"},
                { name: "Philosophy Double Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy-double/minor.html"},
                { name: "Philosophy Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy/extended-minor.html"},
                { name: "Social Data Analytics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/social-data-analytics/minor.html"},
            ],
        },
        "Department of Political Science": {
            "Majors": [
                { name: "French Cohort Program in Public and International Affairs French and Francophone Studies Major with a Political Science Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-cohort-program-in-public-and-international-affairs-french-and-francophone-studies-major-with-a-political-science-extended-minor/bachelor-of-arts.html"},
                { name: "Political Science Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Political Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "French, History and Politics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-history-and-politics/joint-major/bachelor-of-arts.html"},
                { name: "Political Science and Economics Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science-and-economics/joint-major/bachelor-of-arts.html"},
                { name: "Political Science and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Political Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science/minor.html"},
                { name: "Political Science Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/political-science/extended-minor.html"},
                { name: "Social Data Analytics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/social-data-analytics/minor.html"},
            ],
        },
        "Department of Psychology": {
            "Majors": [
                { name: "Behavioural Neuroscience Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/behavioural-neuroscience/major/bachelor-of-science.html"},
                { name: "Psychology Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/psychology/major/bachelor-of-arts.html"},
                { name: "Psychology, Applied Behaviour Analysis Concentration Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/psychology-applied-behaviour-analysis-concentration/major/bachelor-of-arts.html"},
                { name: "Behavioural Neuroscience Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/behavioural-neuroscience/honours/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Behavioural Neuroscience Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/behavioural-neuroscience/honours/bachelor-of-science.html"},
                { name: "Psychology Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/psychology/honours/bachelor-of-arts.html"},
                { name: "Psychology, Applied Behaviour Analysis Concentration Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/psychology-applied-behaviour-analysis-concentration/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Business and Psychology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-psychology/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Criminology and Psychology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology-and-psychology/joint-major/bachelor-of-arts.html"},
                { name: "Gender, Sexuality, and Women's Studies and Psychology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/gender-sexuality-and-women-s-studies-and-psychology/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Psychology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/psychology/minor.html"},
                { name: "Psychology Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/psychology/extended-minor.html"},
            ],
        },
        "Department of World Languages and Literatures": {
            "Majors": [
                { name: "World Literature Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "World Literature Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "World Literature and History Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature-and-history/joint-major/bachelor-of-arts.html"},
                { name: "World Literature and International Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature-and-international-studies/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Italian Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/italian-studies/minor.html"},
                { name: "World Literature Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature/minor.html"},
                { name: "World Literature Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature/extended-minor.html"},
            ]
        },
        "Global Asia Program": {
            "Minors": [
                { name: "Global Asia Minor", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/global-asia/minor.html"},
            ],
        },
        "Indigenous Languages Program": {
            "Minors": [
                { name: "Indigenous Languages Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/indigenous-languages/minor.html"},
            ],
        },
        "Labour Studies Program": {
            "Majors": [
                { name: "Labour Studies Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/labour-studies/major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Labour Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/labour-studies/minor.html"},
            ],
        },
        "Semester in Dialogue": {
            "Minors": [
                { name: "Dialogue Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/dialogue/minor.html"},
            ],
        },
        "School of Criminology": {
            "Majors": [
                { name: "Criminology Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Criminology Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Anthropology and Criminology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-criminology/joint-major/bachelor-of-arts.html"},
                { name: "Criminology and Gender, Sexuality, and Women's Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology-and-gender-sexuality-and-women-s-studies/joint-major/bachelor-of-arts.html"},
                { name: "Criminology and Psychology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology-and-psychology/joint-major/bachelor-of-arts.html"},
                { name: "Sociology and Criminology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology-and-criminology/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Criminology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology/minor.html"},
                { name: "Legal Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/legal-studies/minor.html"},
                { name: "Police Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/police-studies/minor.html"},
                { name: "Criminology Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/criminology/extended-minor.html"},
            ],
        },
        "School for International Studies": {
            "Majors": [
                { name: "International Studies Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/international-studies/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "International Studies Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/international-studies/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "World Literature and International Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/world-literature-and-international-studies/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "International Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/international-studies/minor.html"},
            ]
        },
        "School of Public Policy": {
            "Minors": [
                { name: "Public Policy Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/public-policy/minor.html"},
            ],
        },
        "Urban Studies Program": {
            "Majors": [
                { name: "Urban Worlds Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/urban-worlds/major/bachelor-of-arts.html"},
            ],
        },
    },

    "Faculty of Communication, Art and Technology": {
        "Publishing Program": {
            "Minors": [
                { name: "Print and Digital Publishing Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/print-and-digital-publishing/minor.html"},
            ],
        },
        "School for the Contemporary Arts": {
            "Majors": [
                { name: "Art, Performance and Cinema Studies Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/art-performance-and-cinema-studies/major/bachelor-of-arts.html"},
                { name: "Dance Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/dance/major/bachelor-of-fine-arts.html"},
                { name: "Dance with National Ballet School Teachers' Training Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/dance-with-national-ballet-school-teachers-training/major/bachelor-of-fine-arts.html"},
                { name: "Film Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/film/major/bachelor-of-fine-arts.html"},
                { name: "Music and Sound Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/music-and-sound/major/bachelor-of-fine-arts.html"},
                { name: "Theatre (Production and Design Stream) Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/theatre-production-and-design-stream-/major/bachelor-of-fine-arts.html"},
                { name: "Theatre and Performance Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/theatre-and-performance/major/bachelor-of-fine-arts.html"},
                { name: "Visual Art Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/visual-art/major/bachelor-of-fine-arts.html"},
            ],
            "Honours": [
                { name: "Art, Performance and Cinema Studies Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/art-performance-and-cinema-studies/honours/bachelor-of-arts.html"},
                { name: "Dance Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/dance/honours/bachelor-of-fine-arts.html"},
                { name: "Film Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/film/honours/bachelor-of-fine-arts.html"},
                { name: "Music and Sound Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/music-and-sound/honours/bachelor-of-fine-arts.html"},
                { name: "Theatre (Production and Design Stream) Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/theatre-production-and-design-stream-/honours/bachelor-of-fine-arts.html"},
                { name: "Theatre and Performance Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/theatre-and-performance/honours/bachelor-of-fine-arts.html"},
                { name: "Visual Art Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/visual-art/honours/bachelor-of-fine-arts.html"},
            ],
            "Minors": [
                { name: "Art and Performance Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/art-and-performance-studies/minor.html"},
                { name: "Cinema Studies Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/cinema-studies/minor.html"},
                { name: "Dance Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/dance/extended-minor.html"},
                { name: "Film Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/film/extended-minor.html"},
                { name: "Music and Sound Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/music-and-sound/extended-minor.html"},
                { name: "Theatre Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/theatre/extended-minor.html"},
                { name: "Visual Art Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/visual-art/extended-minor.html"},
            ],
        },
        "School of Communication": {
            "Majors": [
                { name: "Communication Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Communication Honors", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Anthropology and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-communication/joint-major/bachelor-of-arts.html"},
                { name: "Business and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/business-and-communication/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
                { name: "Communication and Interactive Arts and Technology Joint Major (BA)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication-and-interactive-arts-and-technology/joint-major/bachelor-of-arts.html"},
                { name: "Communication and Interactive Arts and Technology Joint Major (BSc)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication-and-interactive-arts-and-technology/joint-major/bachelor-of-science.html"},
                { name: "English and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/english-and-communication/joint-major/bachelor-of-arts.html"},
                { name: "Sociology and Communication Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sociology-and-communication/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Communication Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication/minor.html"},
                { name: "Dialogue Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/dialogue/minor.html"},
                { name: "Communication Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication/extended-minor.html"},
            ],
        },
        "School of Interactive Arts and Technology": {
            "Majors": [
                { name: "Interactive Arts and Technology Major (BA)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/interactive-arts-and-technology/major/bachelor-of-arts.html"},
                { name: "Interactive Arts and Technology Major (BSc)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/interactive-arts-and-technology/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Interactive Arts and Technology Honours (BA)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/interactive-arts-and-technology/honours/bachelor-of-arts.html"},
                { name: "Interactive Arts and Technology Honours (BSc)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/interactive-arts-and-technology/honours/bachelor-of-science.html"},
            ],
            "Joint Majors": [
                { name: "Communication and Interactive Arts and Technology Joint Major (BA)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication-and-interactive-arts-and-technology/joint-major/bachelor-of-arts.html"},
                { name: "Communication and Interactive Arts and Technology Joint Major (BSc)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/communication-and-interactive-arts-and-technology/joint-major/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Interactive Arts and Technology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/interactive-arts-and-technology/minor.html"},
            ],
        }
    },

    "Faculty of Education": {
        "General Education": [
            { name: "Double Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/double-minor/degree/bachelor-of-general-studies.html"},
            { name: "Education, Two Minors or Extended Minors (BEd)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/education-two-minors-or-extended-minors/degree/bachelor-of-education.html"},
            { name: "General Education Option", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/general-education-option/degree/bachelor-of-general-studies.html"},
            { name: "Education Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/education/honours/bachelor-of-education.html"},
        ],
        "Majors": [
            { name: "Education Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/education/major/bachelor-of-education.html"},
        ],
        "Minors": [
            { name: "Counselling and Human Development Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/counselling-and-human-development/minor.html"},
            { name: "Curriculum and Instruction Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/curriculum-and-instruction/minor.html"},
            { name: "Early Learning Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/early-learning/minor.html"},
            { name: "Educational Psychology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/educational-psychology/minor.html"},
            { name: "Elementary Generalist Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/elementary-generalist/minor.html"},
            { name: "Environmental Education Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/environmental-education/minor.html"},
            { name: "French Education Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/french-education/minor.html"},
            { name: "Learning and Developmental Disabilities Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/learning-and-developmental-disabilities/minor.html"},
            { name: "Physical and Health Education Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/physical-and-health-education/minor.html"},
            { name: "Secondary Mathematics Education Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/secondary-mathematics-education/minor.html"},
            { name: "Secondary Teaching Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/secondary-teaching/minor.html"},
            { name: "Social Justice in Education Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/social-justice-in-education/minor.html"},
        ],
    },

    "Faculty of Environment": {
        "Department of Archaeology": {
            "Majors": [
                { name: "Archaeology Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/archaeology/major/bachelor-of-arts.html"},
            ],
            "Honours": [
                { name: "Archaeology Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/archaeology/honours/bachelor-of-arts.html"},
            ],
            "Joint Majors": [
                { name: "Anthropology and Archaeology Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/anthropology-and-archaeology/joint-major/bachelor-of-arts.html"},
                { name: "Archaeology and Indigenous Studies Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/archaeology-and-indigenous-studies/joint-major/bachelor-of-arts.html"},
            ],
            "Minors": [
                { name: "Archaeology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/archaeology/minor.html"},
                { name: "Archaeology Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/archaeology/extended-minor.html"},
            ]
        },
        "Department of Geography": {
            "Majors": [
                { name: "Geographic Information Science Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geographic-information-science/major/bachelor-of-science.html"},
                { name: "Global Environmental Systems Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/global-environmental-systems/major/bachelor-of-environment.html"},
                { name: "Human Geography Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/human-geography/major/bachelor-of-arts.html"},
                { name: "Physical Geography Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/physical-geography/major/bachelor-of-science.html"},
                { name: "Urban Worlds Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/urban-worlds/major/bachelor-of-arts.html"},
            ],
            "Honours": [ 
                { name: "Geographic Information Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geographic-information-science/honours/bachelor-of-science.html"},
                { name: "Global Environmental Systems Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/global-environmental-systems/honours/bachelor-of-environment.html"},
                { name: "Human Geography Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/human-geography/honours/bachelor-of-arts.html"},
                { name: "Physical Geography Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/physical-geography/honours/bachelor-of-science.html"},
            ],
            "Joint Majors": [
                { name: "Geo Business Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geo-business/joint-major/bachelor-of-arts-or-bachelor-of-business-administration.html"},
            ],
            "Minors": [
                { name: "Climate Change and Society Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/climate-change-and-society/minor.html"},
                { name: "Geographic Information Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geographic-information-science/minor.html"},
                { name: "Geography Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geography/minor.html"},
                { name: "Physical Geography Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/physical-geography/minor.html"},
                { name: "Geography Extended Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/geography/extended-minor.html"},
            ],
        },
        "School of Environmental Science": {
            "Majors": [
                { name: "Environmental Science Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/environmental-science/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Environmental Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/environmental-science/honours/bachelor-of-science.html"},
            ]
        },
        "School of Resource and Environmental Management": {
            "Majors": [
                { name: "Resource and Environmental Management Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/resource-and-environmental-management/major/bachelor-of-environment.html"},
            ],
            "Honours": [
                { name: "Resource and Environmental Management Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/resource-and-environmental-management/honours/bachelor-of-environment.html"},
            ],
            "Joint Majors": [
                { name: "Sustainable Business Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sustainable-business/joint-major/bachelor-of-business-administration-or-bachelor-of-environment.html"},
            ],
            "Minors": [
                { name: "Resource and Environmental Management Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/resource-and-environmental-management/minor.html"},
            ],
        },
        "Sustainable Development Program": {
            "Minors": [
                { name: "Sustainable Development Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/sustainable-development/minor.html"},
            ],
        },
    },

    "Faculty of Health Sciences": {
        "Majors": [
            { name: "Health Sciences Major (BA)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/health-sciences/major/bachelor-of-arts.html"},
            { name: "Health Sciences Major (BSc)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/health-sciences/major/bachelor-of-science.html"},
        ],
        "Honours": [
            { name: "Health Sciences Honours (BA)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/health-sciences/honours/bachelor-of-arts.html"},
            { name: "Health Sciences Honours (BSc)", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/health-sciences/honours/bachelor-of-science.html"},
        ],
        "Joint Majors": [
            { name: "Philosophy and Health Sciences Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/philosophy-and-health-sciences/joint-major/bachelor-of-arts.html"},
        ],
        "Minors": [
            { name: "Health Sciences Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/health-sciences/minor.html"},
        ],
    },

    "Faculty of Science": {
        "Department of Biological Sciences": {
            "Majors": [
                { name: "Biological Sciences Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biological-sciences/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Biological Sciences Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biological-sciences/honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Biological Sciences Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biological-sciences/minor.html"},
                { name: "Environmental Toxicology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/environmental-toxicology/minor.html"},
            ],
        },
        "Department of Biomedical Physiology and Kinesiology": {
            "Majors": [
                { name: "Behavioural Neuroscience Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/behavioural-neuroscience/major/bachelor-of-science.html"},
                { name: "Biomedical Physiology Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biomedical-physiology/major/bachelor-of-science.html"},
                { name: "Kinesiology Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/kinesiology/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Behavioural Neuroscience Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/behavioural-neuroscience/honours/bachelor-of-science.html"},
                { name: "Biomedical Physiology Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biomedical-physiology/honours/bachelor-of-science.html"},
                { name: "Kinesiology Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/kinesiology/honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Biomedical Physiology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biomedical-physiology/minor.html"},
                { name: "Kinesiology Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/kinesiology/minor.html"},
            ],
        },
        "Department of Chemistry": {
            "Majors": [
                { name: "Chemical Physics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemical-physics/major/bachelor-of-science.html"},
                { name: "Chemistry Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Chemical Physics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemical-physics/honours/bachelor-of-science.html"},
                { name: "Chemistry Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry/honours/bachelor-of-science.html"},
            ],
            "Joint Majors": [
                { name: "Chemistry and Earth Sciences Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-earth-sciences/joint-major/bachelor-of-science.html"},
                { name: "Chemistry and Molecular Biology and Biochemistry Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-molecular-biology-and-biochemistry/joint-major/bachelor-of-science.html"},
            ],
            "Joint Honours": [
                { name: "Chemistry and Earth Sciences Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-earth-sciences/joint-honours/bachelor-of-science.html"},
                { name: "Chemistry and Molecular Biology and Biochemistry Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-molecular-biology-and-biochemistry/joint-honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Chemistry Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry/minor.html"},
                { name: "Environmental Chemistry Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/environmental-chemistry/minor.html"},
                { name: "Nuclear Science Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/nuclear-science/minor.html"},
            ],
        },
        "Department of Earth Sciences": {
            "Majors": [
                { name: "Earth Sciences Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/earth-sciences/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Earth Sciences Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/earth-sciences/honours/bachelor-of-science.html"},
            ],
            "Joint Majors": [
                { name: "Chemistry and Earth Sciences Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-earth-sciences/joint-major/bachelor-of-science.html"},
            ],
            "Joint Honours": [
                { name: "Chemistry and Earth Sciences Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-earth-sciences/joint-honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Earth Sciences Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/earth-sciences/minor.html"},
            ]
        },
        "Department of Mathematics": {
            "Majors": [
                { name: "Applied Mathematics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/applied-mathematics/major/bachelor-of-science.html"},
                { name: "Mathematics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics/major/bachelor-of-science.html"},
                { name: "Operations Research Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/operations-research/major/bachelor-of-science.html"},

            ],
            "Honours": [
                { name: "Applied Mathematics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/applied-mathematics/honours/bachelor-of-science.html"},
                { name: "Mathematics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics/honours/bachelor-of-science.html"},
                { name: "Mathematical Physics Honours", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/mathematical-physics/honours/bachelor-of-science.html"},
                { name: "Operations Research Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/operations-research/honours/bachelor-of-science.html"},
            ],
            "Joint Majors": [
                { name: "Mathematics and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics-and-computing-science/joint-major/bachelor-of-science.html"},
            ],
            "Joint Honours": [
                { name: "Mathematics and Computing Science Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics-and-computing-science/joint-honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Mathematics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/mathematics/minor.html"},
            ],
        },
        "Department of Molecular Biology and Biochemistry": {
            "Majors": [
                { name: "Molecular Biology and Biochemistry Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Molecular Biology and Biochemistry Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry/honours/bachelor-of-science.html"},
            ],
            "Joint Majors": [
                { name: "Chemistry and Molecular Biology and Biochemistry Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-molecular-biology-and-biochemistry/joint-major/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Business Administration Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-business-administration/joint-major/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Computing Science Joint Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-computing-science/joint-major/bachelor-of-science.html"},
            ],
            "Joint Honours": [
                { name: "Chemistry and Molecular Biology and Biochemistry Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemistry-and-molecular-biology-and-biochemistry/joint-honours/bachelor-of-science.html"},
                { name: "Molecular Biology and Biochemistry and Business Administration Joint Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry-and-business-administration/joint-honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Molecular Biology and Biochemistry Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/molecular-biology-and-biochemistry/minor.html"},
            ],
        },
        "Department of Physics": {
            "Majors": [
                { name: "Applied Physics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/applied-physics/major/bachelor-of-science.html"},
                { name: "Biological Physics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biological-physics/major/bachelor-of-science.html"},
                { name: "Chemical Physics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemical-physics/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Applied Physics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/applied-physics/honours/bachelor-of-science.html"},
                { name: "Biological Physics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/biological-physics/honours/bachelor-of-science.html"},
                { name: "Chemical Physics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/chemical-physics/honours/bachelor-of-science.html"},
                { name: "Mathematical Physics Honours", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/mathematical-physics/honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Nuclear Science Minor", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/nuclear-science/minor.html"},
                { name: "Physics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/physics/minor.html"},
            ],
        },
        "Department of Statistics and Actuarial Science": {
            "Majors": [
                { name: "Actuarial Science Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/actuarial-science/major/bachelor-of-science.html" },
                { name: "Data Science Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/data-science/major/bachelor-of-science.html"},
                { name: "Statistics Major", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/statistics/major/bachelor-of-science.html"},
            ],
            "Honours": [
                { name: "Actuarial Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/actuarial-science/honours/bachelor-of-science.html"},
                { name: "Data Science Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/data-science/honours/bachelor-of-science.html"},
                { name: "Statistics Honours", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/statistics/honours/bachelor-of-science.html"},
            ],
            "Minors": [
                { name: "Statistics Minor", url: "https://www.sfu.ca/students/calendar/2025/spring/programs/statistics/minor.html"},
            ],
        },
        "Science, General": [
            { name: "General Science Double Minor", url: "https://www.sfu.ca/content/sfu/students/calendar/2025/spring/programs/general-science-double-minor/degree/bachelor-of-science.html"},
        ]
    },
};


const NestedGroup = ({ title, content, level }) => {
    const [isOpen, setIsOpen] = useState(false);

    const renderContent = () => {
        if (Array.isArray(content)) {
            return content.map((link, index) => (
                <li key={index}>
                    <a href={link.url} target="_blank" rel="noopener noreferrer">
                        {link.name}
                    </a>
                </li>
            ));
        } else {
            return Object.entries(content).map(([key, value]) => (
                <NestedGroup key={key} title={key} content={value} level={level + 1} />
            ));
        }
    };

    return (
        <div className={'nested_group level_${level}'}>
            <div className="group_title" onClick={() => setIsOpen(!isOpen)}>
                {isOpen ? "- " : "+ "}{title}
            </div>
            {isOpen && (
                <div className="group_content">
                    {Array.isArray(content) ? (
                        <ul>{renderContent()}</ul>
                    ) : (
                        renderContent()
                    )}
                </div>
            )}
        </div>
    );
};

const ExternalLinksSidebar = () => {
    return (
        <div className="external_links_sidebar">
            <h3>Course Planning Links</h3>
            {Object.entries(facultyStructure).map(([faculty, departments]) => (
                <NestedGroup key={faculty} title={faculty} content={departments} level={1} />
            ))}
        </div>
    );
};

export { ExternalLinksSidebar };