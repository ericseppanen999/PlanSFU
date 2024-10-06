
Course.create!(
  dept: "math",
  number: "100",
  term: "fall",
  year: "2024",
  title: "Precalculus",
  description: "Designed to prepare students for first year Calculus courses. Topics include language and notation of mathematics; problem solving; algebraic, exponential, logarithmic and trigonometric functions and their graphs. ",
  requisite_description: "Pre-Calculus 11 or Foundations of Mathematics 11 (or equivalent)
with a grade of at least B or Pre-Calculus 12 (or equivalent), with a grade of at least C and SFU FAN credit, or SFU FAN X99 course with a grade of at least B-, or achieving a satisfactory grade on the Simon Fraser University Quantitative Placement Test. MATH 100 may not be counted towards the mathematics minor, major or honours degree requirements.",
  prereq_logic: "", # implement
  short_description: "Designed to prepare students for first year Calculus courses. Topics include language and notation of mathematics; problem solving; algebraic, exponential, logarithmic and trigonometric functions and their graphs. ",
  credits: 3,
  instructors: [ "Tom Archibald", "Vijaykumar Singh" ],
  campuses: [ "Burnaby", "Surrey" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d400", "op01", "op02" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "130",
  term: "fall",
  year: "2024",
  title: "Geometry for Computer Graphics",
  description: "An introductory course in the application of geometry and linear algebra principles to computer graphical representation.  Vector and matrix algebra, two and three dimensional transformations, homogeneous coordinates, perspective geometry.",
  requisite_description: "Pre-Calculus 12 or Foundations of Mathematics 12 (or equivalent) with a grade of at least B, or MATH 100 with a grade of at least C.",
  prereq_logic: "", # implement
  short_description: "An introductory course in the application of geometry and linear algebra principles to computer graphical representation.  Vector and matrix algebra, two and three dimensional transformations, homogeneous coordinates, perspective geometry.",
  credits: 3,
  instructors: [ "Alexander Rutherford" ],
  campuses: [ "Surrey" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d400", "op01" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "150",
  term: "fall",
  year: "2024",
  title: "Calculus I with Review",
  description: "Designed for students specializing in mathematics, physics, chemistry, computing science and engineering. Topics as for Math 151 with a more extensive review of functions, their properties and their graphs. Recommended for students with no previous knowledge of Calculus. In addition to regularly scheduled lectures, students enrolled in this course are encouraged to come for assistance to the Calculus Workshop (Burnaby), or Math Open Lab (Surrey). ",
  requisite_description: "Pre-Calculus 12 (or equivalent) with a grade of at least B+, or MATH 100 with a grade of at least B-, or achieving a satisfactory grade on the Simon Fraser University Calculus Readiness Test.",
  prereq_logic: "", # implement
  short_description: "Designed for students specializing in mathematics, physics, chemistry, computing science and engineering. Topics as for Math 151 with a more extensive review of functions, their properties and their graphs. Recommended for students with no previous knowledge of Calculus. In addition to regularly scheduled lectures, students enrolled in this course are encouraged to come for assistance to the Calculus Workshop (Burnaby), or Math Open Lab (Surrey). ",
  credits: 4,
  instructors: [ "Jamie Mulholland", "MacKenzie Carr", "Natalia Kouzniak" ],
  campuses: [ "Burnaby", "Surrey", nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "d400", "op01" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "151",
  term: "fall",
  year: "2024",
  title: "Calculus I",
  description: "Designed for students specializing in mathematics, physics, chemistry, computing science and engineering. Logarithmic and exponential functions, trigonometric functions, inverse functions. Limits, continuity, and derivatives. Techniques of differentiation, including logarithmic and implicit differentiation. The Mean Value Theorem. Applications of differentiation including extrema, curve sketching, Newton's method. Introduction to modeling with differential equations. Polar coordinates, parametric curves. ",
  requisite_description: "Pre-Calculus 12 (or equivalent) with a grade of at least A, or MATH 100 with a grade of at least B, or achieving a satisfactory grade on the Simon Fraser University Calculus Readiness Test.",
  prereq_logic: "", # implement
  short_description: "Designed for students specializing in mathematics, physics, chemistry, computing science and engineering. Logarithmic and exponential functions, trigonometric functions, inverse functions. Limits, continuity, and derivatives. Techniques of differentiation, including logarithmic and implicit differentiation. The Mean Value Theorem. Applications of differentiation including extrema, curve sketching, Newton's method. Introduction to modeling with differential equations. Polar coordinates, parametric curves. ",
  credits: 3,
  instructors: [ "Jamie Mulholland", "MacKenzie Carr", "Natalia Kouzniak" ],
  campuses: [ "Burnaby", "Surrey" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "d400", "op01", "op04" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "152",
  term: "fall",
  year: "2024",
  title: "Calculus II",
  description: "Riemann sum, Fundamental Theorem of Calculus, definite, indefinite and improper integrals, approximate integration, integration techniques, applications of integration. First-order separable differential equations and growth models. Sequences and series, series tests, power series, convergence and applications of power series.",
  requisite_description: "MATH 150 or 151, with a minimum grade of C-; or MATH 154 or 157 with a grade of at least B.",
  prereq_logic: "", # implement
  short_description: "Riemann sum, Fundamental Theorem of Calculus, definite, indefinite and improper integrals, approximate integration, integration techniques, applications of integration. First-order separable differential equations and growth models. Sequences and series, series tests, power series, convergence and applications of power series.",
  credits: 3,
  instructors: [ "Lyn Ge" ],
  campuses: [ "Burnaby", nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "op01" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "154",
  term: "fall",
  year: "2024",
  title: "Mathematics for the Life Sciences I",
  description: "Designed for students specializing in the life sciences. Topics include: limits, growth rate and the derivative; elementary functions, optimization and approximation methods, and their applications, integration, and differential equations; mathematical models of biological processes and their implementation and analysis using software.",
  requisite_description: "Pre-Calculus 12 (or equivalent) with a grade of at least B, or MATH 100 with a grade of at least C-, or achieving a satisfactory grade on the Simon Fraser University Calculus Readiness Test.",
  prereq_logic: "", # implement
  short_description: "Designed for students specializing in the life sciences. Topics include: limits, growth rate and the derivative; elementary functions, optimization and approximation methods, and their applications, integration, and differential equations; mathematical models of biological processes and their implementation and analysis using software.",
  credits: 3,
  instructors: [ "Cedric Chauve", "Ladislav Stacho" ],
  campuses: [ "Burnaby", "Surrey", nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d400", "op01", "op02" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "157",
  term: "fall",
  year: "2024",
  title: "Calculus I for the Social Sciences",
  description: "Designed for students specializing in business or the social sciences. Topics include: limits, growth rate and the derivative; logarithmic, exponential and trigonometric functions and their application to business, economics, optimization and approximation methods; introduction to functions of several variables with emphasis on partial derivatives and extrema.",
  requisite_description: "Pre-Calculus 12 (or equivalent) with a grade of at least B, or MATH 100 with a grade of at least C, or achieving a

satisfactory grade on the Simon Fraser University Calculus

Readiness Test.",
  prereq_logic: "", # implement
  short_description: "Designed for students specializing in business or the social sciences. Topics include: limits, growth rate and the derivative; logarithmic, exponential and trigonometric functions and their application to business, economics, optimization and approximation methods; introduction to functions of several variables with emphasis on partial derivatives and extrema.",
  credits: 3,
  instructors: [ "Katrina Honigs", "Tamon Stephen" ],
  campuses: [ "Burnaby", "Surrey", nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d400", "op01", "op02" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "190",
  term: "fall",
  year: "2024",
  title: "Principles of Mathematics for Teachers",
  description: "Designed for students pursuing a career as an elementary school teacher. Topics are drawn from number systems as well as plane, solid, and metric geometry. Examination of the historical and cultural development of mathematical ideas and their place in contemporary mathematics. Emphasis on deep understanding of mathematical concepts and on multiple representations: physical, pictorial, and symbolic. Detailed topics include: problem solving, bases, whole and fractional numbers and their arithmetic operations, number theory, ratios, rates, percent, polygons, polyhedra, symmetries, transformations, and measurements.",
  requisite_description: "Pre-Calculus 11 or Foundations of Mathematics 11 (or equivalent)

with a grade of at least B, or SFU FAN X99 course with a grade of at least C, or achieving a satisfactory grade on the Simon Fraser University Quantitative Placement Test. This course may not be counted toward the Mathematics minor, major or honours degree requirements. Students who have taken, have received transfer credit for, or are currently taking MATH 150, 151, 154 or 157 may not take MATH 190 for credit without permission from the Department of Mathematics. Intended to be particularly accessible to students who are not specializing in mathematics.",
  prereq_logic: "", # implement
  short_description: "Designed for students pursuing a career as an elementary school teacher. Topics are drawn from number systems as well as plane, solid, and metric geometry. Examination of the historical and cultural development of mathematical ideas and their place in contemporary mathematics. Emphasis on deep understanding of mathematical concepts and on multiple representations: physical, pictorial, and symbolic. Detailed topics include: problem solving, bases, whole and fractional numbers and their arithmetic operations, number theory, ratios, rates, percent, polygons, polyhedra, symmetries, transformations, and measurements.",
  credits: 4,
  instructors: [ "Sheena Tan", "Joanna Niezen" ],
  campuses: [ "Burnaby", nil ],
  delivery_methods: [ "Blended", "Online", "In Person" ],
  sections: [ "b100", "ol01", "op01" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "232",
  term: "fall",
  year: "2024",
  title: "Applied Linear Algebra",
  description: "Linear equations, matrices, determinants. Introduction to vector spaces and linear transformations and bases. Complex numbers. Eigenvalues and eigenvectors; diagonalization. Inner products and orthogonality; least squares problems. An emphasis on applications involving matrix and vector calculations.",
  requisite_description: "MATH 150 or 151 or MACM 101, with a minimum grade of C-; or MATH 154 or 157, both with a grade of at least B.",
  prereq_logic: "", # implement
  short_description: "Linear equations, matrices, determinants. Introduction to vector spaces and linear transformations and bases. Complex numbers. Eigenvalues and eigenvectors; diagonalization. Inner products and orthogonality; least squares problems. An emphasis on applications involving matrix and vector calculations.",
  credits: 3,
  instructors: [ "Saieed Akbari Feyzaabaadi", "Vijaykumar Singh" ],
  campuses: [ "Burnaby", "Surrey", nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d400", "op01", "op02" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "240",
  term: "fall",
  year: "2024",
  title: "Algebra I: Linear Algebra",
  description: "Linear equations, matrices, determinants. Real and abstract vector spaces, subspaces and linear transformations; basis and change of basis. Complex numbers. Eigenvalues and eigenvectors; diagonalization. Inner products and orthogonality; least squares problems. Applications. Subject is presented with an abstract emphasis and includes proofs of the basic theorems.",
  requisite_description: "MATH 150 or 151 or MACM 101, with a minimum grade of C-; or MATH 154 or 157, both with a grade of at least B.",
  prereq_logic: "", # implement
  short_description: "Linear equations, matrices, determinants. Real and abstract vector spaces, subspaces and linear transformations; basis and change of basis. Complex numbers. Eigenvalues and eigenvectors; diagonalization. Inner products and orthogonality; least squares problems. Applications. Subject is presented with an abstract emphasis and includes proofs of the basic theorems.",
  credits: 3,
  instructors: [ "Michael Monagan" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "op01" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "251",
  term: "fall",
  year: "2024",
  title: "Calculus III",
  description: "Rectangular, cylindrical and spherical coordinates. Vectors, lines, planes, cylinders, quadric surfaces. Vector functions, curves, motion in space. Differential and integral calculus of several variables. Vector fields, line integrals, fundamental theorem for line integrals, Green's theorem.",
  requisite_description: "MATH 152 with a minimum grade of C-; or MATH 155 or MATH 158 with a grade of at least B. Recommended: It is recommended that MATH 240 or 232 be taken before or concurrently with MATH 251.",
  prereq_logic: "", # implement
  short_description: "Rectangular, cylindrical and spherical coordinates. Vectors, lines, planes, cylinders, quadric surfaces. Vector functions, curves, motion in space. Differential and integral calculus of several variables. Vector fields, line integrals, fundamental theorem for line integrals, Green's theorem.",
  credits: 3,
  instructors: [ "Weiran Sun", "Justin Gray", "Justin Chan" ],
  campuses: [ "Burnaby", "Surrey" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "d400", "op01", "op02" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "260",
  term: "fall",
  year: "2024",
  title: "Introduction to Ordinary Differential Equations",
  description: "First-order differential equations, second- and higher-order linear equations, series solutions, introduction to Laplace transform, systems and numerical methods, applications in the physical, biological and social sciences.",
  requisite_description: "MATH 152 with a minimum grade of C-; or MATH 155 or 158, with a grade of at least B; MATH 232 or 240, with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "First-order differential equations, second- and higher-order linear equations, series solutions, introduction to Laplace transform, systems and numerical methods, applications in the physical, biological and social sciences.",
  credits: 3,
  instructors: [ "Ahmad Mokhtar", "Justin Chan" ],
  campuses: [ "Burnaby", "Surrey" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d400" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "292",
  term: "fall",
  year: "2024",
  title: "Selected Topics in Mathematics",
  description: "Topics will vary from term to term depending on faculty availability and student interest.",
  requisite_description: "Prerequisites will be specified according to the particular topic or topics offered.",
  prereq_logic: "", # implement
  short_description: "Topics will vary from term to term depending on faculty availability and student interest.",
  credits: 3,
  instructors: [ "Joanna Niezen" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "303",
  term: "fall",
  year: "2024",
  title: "Mathematical Journeys III",
  description: "A focused exploration of a special topic (varying from term to term) that builds on mathematical ideas from lower division courses and provides further challenges in quantitative and deductive reasoning. Each Journeys course is designed to appeal particularly to mathematics minor students and others with a broad interest in mathematics. Students may repeat this course for further credit under a different topic.",
  requisite_description: "MATH 152 or 155 or 158, and MATH 232 or 240, all with a minimum grade of C-. There may be additional prerequisites depending on the specific course topic.",
  prereq_logic: "", # implement
  short_description: "A focused exploration of a special topic (varying from term to term) that builds on mathematical ideas from lower division courses and provides further challenges in quantitative and deductive reasoning. Each Journeys course is designed to appeal particularly to mathematics minor students and others with a broad interest in mathematics. Students may repeat this course for further credit under a different topic.",
  credits: 3,
  instructors: [ "John Stockie" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "308",
  term: "fall",
  year: "2024",
  title: "Linear Optimization",
  description: "Linear programming modelling. The simplex method and its variants. Duality theory. Post-optimality analysis. Applications and software. Additional topics may include: game theory, network simplex algorithm, and convex sets.",
  requisite_description: "MATH 150, 151, 154, or 157 and MATH 240 or 232, all with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "Linear programming modelling. The simplex method and its variants. Duality theory. Post-optimality analysis. Applications and software. Additional topics may include: game theory, network simplex algorithm, and convex sets.",
  credits: 3,
  instructors: [ "Luis Goddyn" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "309",
  term: "fall",
  year: "2024",
  title: "Continuous Optimization",
  description: "Theoretical and computational methods for investigating the minimum of a function of several real variables with and without inequality constraints. Applications to operations research, model fitting, and economic theory.",
  requisite_description: "MATH 232 or 240, and 251, all with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "Theoretical and computational methods for investigating the minimum of a function of several real variables with and without inequality constraints. Applications to operations research, model fitting, and economic theory.",
  credits: 3,
  instructors: [ "Benjamin Adcock" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "322",
  term: "fall",
  year: "2024",
  title: "Complex Variables",
  description: "Functions of a complex variable, differentiability, contour integrals, Cauchy's theorem, Taylor and Laurent expansions, method of residues.",
  requisite_description: "MATH 251 with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "Functions of a complex variable, differentiability, contour integrals, Cauchy's theorem, Taylor and Laurent expansions, method of residues.",
  credits: 3,
  instructors: [ "David Muraki" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "336",
  term: "fall",
  year: "2024",
  title: "Job Practicum I",
  description: "This is the first term of work experience in a co-operative education program available to mathematics students. Interested students should contact departmental advisors as early in their careers as possible, for proper counselling. Units from this course do not count towards the units required for an SFU degree.",
  requisite_description: "Students must apply to and receive permission from the co-op co-ordinator at least one, preferably two, terms in advance. They will normally be required to have completed 45 units with a GPA of 2.5. This course will be graded on a pass/withdraw basis. A course fee is required.",
  prereq_logic: "", # implement
  short_description: "This is the first term of work experience in a co-operative education program available to mathematics students. Interested students should contact departmental advisors as early in their careers as possible, for proper counselling. Units from this course do not count towards the units required for an SFU degree.",
  credits: 3,
  instructors: [ "Magnus Billings" ],
  campuses: [ nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "i100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "337",
  term: "fall",
  year: "2024",
  title: "Job Practicum II",
  description: "This is the second term of work experience in a co-operative education program available to mathematics students. Units from this course do not count towards the units required for an SFU degree. This course will be graded on a pass/withdraw basis. A course fee is required.",
  requisite_description: "MATH 336 and permission of the co-op co-ordinator; students must apply at least one term in advance.",
  prereq_logic: "", # implement
  short_description: "This is the second term of work experience in a co-operative education program available to mathematics students. Units from this course do not count towards the units required for an SFU degree. This course will be graded on a pass/withdraw basis. A course fee is required.",
  credits: 3,
  instructors: [ "Magnus Billings" ],
  campuses: [ nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "i100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "340",
  term: "fall",
  year: "2024",
  title: "Algebra II: Rings and Fields",
  description: "The integers, fundamental theorem of arithmetic. Equivalence relations, modular arithmetic. Univariate polynomials, unique factorization. Rings and fields. Units, zero divisors, integral domains. Ideals, ring homomorphisms. Quotient rings, the ring isomorphism theorem. Chinese remainder theorem. Euclidean, principal ideal, and unique factorization domains. Field extensions, minimal polynomials. Classification of finite fields.",
  requisite_description: "MATH 240 with a minimum grade of C- or MATH 232 with a grade of at least B.",
  prereq_logic: "", # implement
  short_description: "The integers, fundamental theorem of arithmetic. Equivalence relations, modular arithmetic. Univariate polynomials, unique factorization. Rings and fields. Units, zero divisors, integral domains. Ideals, ring homomorphisms. Quotient rings, the ring isomorphism theorem. Chinese remainder theorem. Euclidean, principal ideal, and unique factorization domains. Field extensions, minimal polynomials. Classification of finite fields.",
  credits: 3,
  instructors: [ "Nathan Ilten" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "343",
  term: "fall",
  year: "2024",
  title: "Applied Discrete Mathematics",
  description: "Structures and algorithms, generating elementary combinatorial objects, counting (integer partitions, set partitions, Catalan families), backtracking algorithms, branch and bound, heuristic search algorithms.",
  requisite_description: "MACM 201 with a minimum grade of C-. Recommended: Knowledge of a programming language.",
  prereq_logic: "", # implement
  short_description: "Structures and algorithms, generating elementary combinatorial objects, counting (integer partitions, set partitions, Catalan families), backtracking algorithms, branch and bound, heuristic search algorithms.",
  credits: 3,
  instructors: [ "Luis Goddyn" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "345",
  term: "fall",
  year: "2024",
  title: "Introduction to Graph Theory",
  description: "Fundamental concepts, trees and distances, matchings and factors, connectivity and paths, network flows, integral flows.",
  requisite_description: "MACM 201 with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "Fundamental concepts, trees and distances, matchings and factors, connectivity and paths, network flows, integral flows.",
  credits: 3,
  instructors: [ "Bojan Mohar" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "360",
  term: "fall",
  year: "2024",
  title: "Introduction to Biomathematics",
  description: "Key ideas and mathematical methods used in applications of mathematics to various biological, ecological, physiological, and medical problems. The course derives, interprets, solves and simulates models of biological systems. Topics could include population models, evolution from trait and genetic perspectives and qualitative analysis of ODEs.",
  requisite_description: "MATH 260 with a minimum grade of C- OR MATH 155 with a minimum grade of A-. Strongly Recommended: Experience with a computing platform such as R, MATLAB, or Python.",
  prereq_logic: "", # implement
  short_description: "Key ideas and mathematical methods used in applications of mathematics to various biological, ecological, physiological, and medical problems. The course derives, interprets, solves and simulates models of biological systems. Topics could include population models, evolution from trait and genetic perspectives and qualitative analysis of ODEs.",
  credits: 3,
  instructors: [ "Ben Ashby" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "408",
  term: "fall",
  year: "2024",
  title: "Discrete Optimization",
  description: "Model building using integer variables, computer solution, relaxations and lower bounds, heuristics and upper bounds, branch and bound algorithms, cutting plane algorithms, valid inequalities and facets, branch and cut algorithms, Lagrangian duality, column generation of algorithms, heuristics algorithms and analysis. ",
  requisite_description: "MATH 308 with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "Model building using integer variables, computer solution, relaxations and lower bounds, heuristics and upper bounds, branch and bound algorithms, cutting plane algorithms, valid inequalities and facets, branch and cut algorithms, Lagrangian duality, column generation of algorithms, heuristics algorithms and analysis. ",
  credits: 3,
  instructors: [ "Tamon Stephen" ],
  campuses: [ "Surrey" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "418",
  term: "fall",
  year: "2024",
  title: "Partial Differential Equations",
  description: "First-order linear equations, the method of characteristics. The wave equation. Harmonic functions, the maximum principle, Green's functions. The heat equation. Distributions and transforms. Higher dimensional eigenvalue problems. An introduction to nonlinear equations. Burgers' equation and shock waves.",
  requisite_description: "(MATH 260 or MATH 310) and one of MATH 314, MATH 320, MATH 322, PHYS 384, all with a minimum grade of C-. An alternative to the above prerequisite is both of (MATH 252 or MATH 254) and (MATH 260 or MATH 310), both with grades of at least A-.",
  prereq_logic: "", # implement
  short_description: "First-order linear equations, the method of characteristics. The wave equation. Harmonic functions, the maximum principle, Green's functions. The heat equation. Distributions and transforms. Higher dimensional eigenvalue problems. An introduction to nonlinear equations. Burgers' equation and shock waves.",
  credits: 3,
  instructors: [ "Weiran Sun" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "436",
  term: "fall",
  year: "2024",
  title: "Job Practicum III",
  description: "This is the third term of work experience in a co-operative education program available to mathematics students. Units from this course do not count towards the units required for an SFU degree. This course will be graded on a pass/withdraw basis. A course fee is required.",
  requisite_description: "MATH 337 and permission of the co-op co-ordinator; students must apply at least one term in advance.",
  prereq_logic: "", # implement
  short_description: "This is the third term of work experience in a co-operative education program available to mathematics students. Units from this course do not count towards the units required for an SFU degree. This course will be graded on a pass/withdraw basis. A course fee is required.",
  credits: 3,
  instructors: [ "Magnus Billings" ],
  campuses: [ nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "i100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "437",
  term: "fall",
  year: "2024",
  title: "Job Practicum IV",
  description: "This is the fourth term of work experience in a co-operative education program available to mathematics students. Units from this course do not count towards the units required for an SFU degree. This course will be graded on a pass/withdraw basis. A course fee is required.",
  requisite_description: "MATH 436 and permission of the co-op co-ordinator; students must apply at least one term in advance.",
  prereq_logic: "", # implement
  short_description: "This is the fourth term of work experience in a co-operative education program available to mathematics students. Units from this course do not count towards the units required for an SFU degree. This course will be graded on a pass/withdraw basis. A course fee is required.",
  credits: 3,
  instructors: [ "Magnus Billings" ],
  campuses: [ nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "i100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "447",
  term: "fall",
  year: "2024",
  title: "Coding Theory",
  description: "An introduction to the theory and practice of error-correcting codes. Topics will include finite fields, polynomial rings, linear and non-linear codes, BCH codes, convolutional codes, majority logic decoding, weight distribution of codes, and bounds on the size of codes.",
  requisite_description: "MATH 340 or 332, with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "An introduction to the theory and practice of error-correcting codes. Topics will include finite fields, polynomial rings, linear and non-linear codes, BCH codes, convolutional codes, majority logic decoding, weight distribution of codes, and bounds on the size of codes.",
  credits: 3,
  instructors: [ "Jonathan Jedwab" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "450",
  term: "fall",
  year: "2024",
  title: "Introduction to Topology",
  description: "Point set topology: definition, continuous maps, homeomorphisms, product and quotient topologies, Hausdorff topologies, connectedness, compactness and compactifications. Algebraic topology: paths, homotopies, fundamental group, universal covering spaces.",
  requisite_description: "MATH 242 and MATH 340, with a minimum grade of C-.",
  prereq_logic: "", # implement
  short_description: "Point set topology: definition, continuous maps, homeomorphisms, product and quotient topologies, Hausdorff topologies, connectedness, compactness and compactifications. Algebraic topology: paths, homotopies, fundamental group, universal covering spaces.",
  credits: 3,
  instructors: [ "Imin Chen" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "480w",
  term: "fall",
  year: "2024",
  title: "The Art and Craft of Problem Solving",
  description: "Designed for students with a strong interest in problem solving and the determination to persevere in seeking solutions to highly challenging mathematical problems. Intended as a preparation for the Putnam Competition, the most challenging and prestigious undergraduate mathematics competition in North America, in which effective presentation of solutions is as important as skill in problem solving. Reviews strategic principles, tactical approaches, and specific technical tools for problem solving, and mathematical problem solving folklore. Emphasis is placed on clarity of exposition and persuasiveness of written argument, and on development of communication skills. Students interested in MATH 480W are encouraged to take the course as soon as they meet the prerequisites, since performance in the Putnam Competition often improves with second and subsequent attempts. ",
  requisite_description: "MACM 201 with a grade of at least B. At least one of MACM 201, MATH 240, MATH 242, MATH 251, MATH 252 with a grade of at least A, or both of MACM 203, MACM 204 with a grade of at least A. Or permission of the instructor.",
  prereq_logic: "", # implement
  short_description: "Designed for students with a strong interest in problem solving and the determination to persevere in seeking solutions to highly challenging mathematical problems. Intended as a preparation for the Putnam Competition, the most challenging and prestigious undergraduate mathematics competition in North America, in which effective presentation of solutions is as important as skill in problem solving. Reviews strategic principles, tactical approaches, and specific technical tools for problem solving, and mathematical problem solving folklore. Emphasis is placed on clarity of exposition and persuasiveness of written argument, and on development of communication skills. Students interested in MATH 480W are encouraged to take the course as soon as they meet the prerequisites, since performance in the Putnam Competition often improves with second and subsequent attempts. ",
  credits: 3,
  instructors: [ "Jonathan Jedwab" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "486",
  term: "fall",
  year: "2024",
  title: "Job Practicum V",
  description: "This is an optional fifth term of work experience in a co-operative education program available to mathematics and statistics students. Units from this course do not count towards the units required for an SFU degree. This course may be repeated for additive credit.",
  requisite_description: "MATH 437 and permission of the co-op co-ordinator. Students must apply at least one term in advance.",
  prereq_logic: "", # implement
  short_description: "This is an optional fifth term of work experience in a co-operative education program available to mathematics and statistics students. Units from this course do not count towards the units required for an SFU degree. This course may be repeated for additive credit.",
  credits: 3,
  instructors: [ "Magnus Billings" ],
  campuses: [ nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100", "d200", "i100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "498",
  term: "fall",
  year: "2024",
  title: "Communication and Research Skills in the Mathematical Sciences",
  description: "Students will develop skills required for mathematical research. This course will focus on communication in both written and oral form. Students will write documents and prepare presentations in a variety of formats for academic and non-academic purposes. The LaTeX document preparation system will be used. Course will be given on a pass/fail basis. ",
  requisite_description: "",
  prereq_logic: "", # implement
  short_description: "Students will develop skills required for mathematical research. This course will focus on communication in both written and oral form. Students will write documents and prepare presentations in a variety of formats for academic and non-academic purposes. The LaTeX document preparation system will be used. Course will be given on a pass/fail basis. ",
  credits: 1,
  instructors: [ "Amarpreet Rattan" ],
  campuses: [ "Burnaby" ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
Course.create!(
  dept: "math",
  number: "499w",
  term: "fall",
  year: "2024",
  title: "Honours Research Project",
  description: "An honours research project in mathematics is an original presentation of an area or problem in mathematics. A typical project is an original synthesis of knowledge generated from students research experience. A project can contain substantive, original mathematics, but need not. The presentation consists of a written report and an oral presentation both of which must be completed before the end of the exam period. ",
  requisite_description: "18 units of upper division MATH or MACM courses. Must be in an honours program with a GPA of at least 3.0. Corequisite: MATH 498. Students must have an approved project prior to enrollment.",
  prereq_logic: "", # implement
  short_description: "An honours research project in mathematics is an original presentation of an area or problem in mathematics. A typical project is an original synthesis of knowledge generated from students research experience. A project can contain substantive, original mathematics, but need not. The presentation consists of a written report and an oral presentation both of which must be completed before the end of the exam period. ",
  credits: 5,
  instructors: [],
  campuses: [ nil ],
  delivery_methods: [ "In Person" ],
  sections: [ "d100" ],
  requisites: [],
)
