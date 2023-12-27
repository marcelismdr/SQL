-- 8.1 Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.
SELECT physician.name
FROM ex_08.undergoes AS main
	LEFT JOIN ex_08.physician AS physician ON main.physician = physician.employeeID
WHERE main.procedures NOT IN (
	SELECT main.procedures
	FROM ex_08.undergoes AS main
	LEFT JOIN ex_08.trained_in AS trained ON main.physician = trained.physician
	WHERE trained.treatment = main.procedures
	);

-- 8.2 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.
SELECT physician.name AS Physician, procedure.name AS Procedure, main.dateundergoes AS date, patient.name AS patient
FROM ex_08.undergoes AS main
	LEFT JOIN ex_08.physician AS physician ON main.physician = physician.employeeID
	LEFT JOIN ex_08.patient AS patient ON main.patient = patient.ssn
	LEFT JOIN ex_08.procedures AS procedure ON main.procedures = procedure.code
WHERE main.procedures NOT IN (
	SELECT main.procedures
	FROM ex_08.undergoes AS main
	LEFT JOIN ex_08.trained_in AS trained ON main.physician = trained.physician
	WHERE trained.treatment = main.procedures
	);

-- 8.3 Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).
SELECT physician.name
FROM ex_08.undergoes AS main
	LEFT JOIN ex_08.physician AS physician ON main.physician = physician.employeeID
	LEFT JOIN ex_08.Trained_in AS trained ON physician.employeeID = trained.physician
WHERE 
	main.procedures IN (
		SELECT main.procedures
		FROM ex_08.undergoes AS main
		LEFT JOIN ex_08.trained_in AS trained ON main.physician = trained.physician
		WHERE trained.treatment = main.procedures)
	AND trained.treatment = main.procedures
	AND trained.certificationexpires < main.dateundergoes
;

-- 8.4 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on, and date when the certification expired.
SELECT physician.name AS Physician, procedure.name AS Procedure, main.dateundergoes AS date, patient.name AS patient
FROM ex_08.undergoes AS main
	LEFT JOIN ex_08.physician AS physician ON main.physician = physician.employeeID
	LEFT JOIN ex_08.patient AS patient ON main.patient = patient.ssn
	LEFT JOIN ex_08.procedures AS procedure ON main.procedures = procedure.code
	LEFT JOIN ex_08.trained_in AS trained ON physician.employeeID = trained.physician
WHERE 
	main.procedures IN (
		SELECT main.procedures
		FROM ex_08.undergoes AS main
		LEFT JOIN ex_08.trained_in AS trained ON main.physician = trained.physician
		WHERE trained.treatment = main.procedures)
	AND trained.treatment = main.procedures
	AND trained.certificationexpires < main.dateundergoes
;

-- 8.5 Obtain the information for appointments where a patient met with a physician other than his/her primary care physician. Show the following information: Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.
SELECT patient.name AS patient, physician.name AS physician, nurse.name AS nurse, appointment.cstart AS appointment_start, appointment.cend AS appointment_end, appointment.examinationroom AS examination_room, main_physician.name AS primary_care_physician
FROM 
	(SELECT appointment.*, patient.pcp
	 FROM ex_08.appointment AS appointment
	 LEFT JOIN ex_08.patient AS patient ON appointment.patient = patient.ssn
	)AS appointment
	LEFT JOIN ex_08.patient AS patient ON appointment.patient = patient.ssn
	LEFT JOIN ex_08.physician AS physician ON appointment.physician = physician.employeeid
	LEFT JOIN ex_08.nurse AS nurse ON appointment.prepnurse = nurse.employeeid
	LEFT JOIN ex_08.physician AS main_physician ON appointment.pcp = main_physician.employeeid
WHERE
	appointment.physician != patient.pcp;

-- 8.6 The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. There are no constraints in force to prevent inconsistencies between these two tables. More specifically, the Undergoes table may include a row where the patient ID does not match the one we would obtain from the Stay table through the Undergoes.Stay foreign key. Select all rows from Undergoes that exhibit this inconsistency.
SELECT undergoes.*
FROM ex_08.patient AS patient
	LEFT JOIN ex_08.undergoes AS undergoes ON patient.ssn = undergoes.patient
	LEFT JOIN ex_08.stay AS stay ON patient.ssn = stay.patient
WHERE undergoes.patient != stay.patient
	OR undergoes.stay != stay.stayid;

-- 8.7 The hospital has several examination rooms where appointments take place. Obtain the number of appointments that have taken place in each examination room.
SELECT examinationroom, COUNT(appointmentid)
FROM ex_08.appointment
GROUP BY examinationroom
ORDER BY examinationroom;

-- 8.8 Obtain the names of all patients (also include, for each patient, the name of the patient's primary care physician), such that \emph{all} the following are true:
    -- The patient has been prescribed some medication by his/her primary care physician.
    -- The patient has undergone a procedure with a cost larger that $5,000
    -- The patient has had at least two appointment where the nurse who prepped the appointment was a registered nurse.
    -- The patient's primary care physician is not the head of any department.
SELECT patient, pcp
FROM (
	SELECT patient.name AS patient, physician.name AS pcp, count(patient.name) AS num_appointments
	FROM ex_08.patient AS patient
		LEFT JOIN ex_08.physician AS physician ON patient.pcp = physician.employeeid
		LEFT JOIN ex_08.undergoes AS undergoes ON patient.ssn = undergoes.patient
		LEFT JOIN ex_08.procedures AS procedures ON undergoes.procedures = procedures.code
		LEFT JOIN ex_08.prescribes AS prescribes ON patient.ssn = prescribes.patient
		LEFT JOIN ex_08.appointment AS appointment ON patient.ssn = appointment.patient
		LEFT JOIN ex_08.nurse AS nurse ON appointment.prepnurse = nurse.employeeid
	WHERE
		nurse.name IS NOT NULL
		AND procedures.cost > 5000
		AND patient.pcp NOT IN (SELECT head FROM ex_08.department)
		AND patient.pcp = prescribes.physician
	GROUP BY patient.name, physician.name
	) AS sub_q
WHERE num_appointments > 1

