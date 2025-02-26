import pandas as pd
from faker import Faker
from tqdm import tqdm
import random

fake = Faker('pl_PL')

Webinars = pd.read_csv("Webinars.csv")
StationaryMeeting = pd.read_csv('StationaryMeeting.csv')
OnlineSyncMeeting = pd.read_csv('OnlineSyncMeeting.csv')
HybridMeetings = pd.read_csv('HybridMeetings.csv')
AcademicMeeting = pd.read_csv('AcademicMeeting.csv')
Courses = pd.read_csv('Courses.csv')
CourseModules = pd.read_csv('CourseModules.csv')
HybridModules = pd.read_csv('HybridModules.csv')
StationaryModule = pd.read_csv('StationaryModule.csv')
OnlineSyncModule = pd.read_csv('OnlineSyncModule.csv')
Studies = pd.read_csv('Studies.csv')
Subjects = pd.read_csv('Subjects.csv')

students_num = 300
courses_num = 15
studies_num = 15
webinars_num = 40
academic_meetings_num = 139
course_id = studies_id = webinar_id = academic_meeting_id = 0 # przechodzimy na modulo

orders = []
ordercontentdetails = []
order_webinars = []
webinardetails = []
payments = []
orderacademicmeetings = []
meetingattendance = []
ordercourses = []
coursestudentdetails = []
moduleattendance = []
orderstudies = []
studentstudiesdetails = []
StudentSubjectDetails = []
StudentInternshipDetails = []

for i in tqdm(range(1, students_num + 1)):
    state = fake.boolean()
    date = fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S')
    order = {
        "OrderID": i,
        "StudentID": i,
        "OrderDate": date,
        "FullyPaidDate": date,
        "PaymentLink": fake.uri(),
        "CurrencyID": 1,
        "vatID": 1
    }
    orders.append(order)

    ordercontentdetail = {
        "OrderContentID": i,
        "OrderID": i
    }
    ordercontentdetails.append(ordercontentdetail)

    to_pay = 0

    course_id = (course_id % courses_num) + 1
    studies_id = (studies_id % studies_num) + 1
    webinar_id = (webinar_id % webinars_num) + 1
    academic_meeting_id = (academic_meeting_id % academic_meetings_num) + 1 # tutaj jest problem z indeksami niestety
    if academic_meeting_id > 120 and academic_meeting_id % 2 == 0: # fix
        academic_meeting_id += 1

    webinar ={
        "OrderContentID": i,
        "WebinarID": webinar_id
    }
    order_webinars.append(webinar)

    to_pay += Webinars.query('WebinarID == @webinar_id')['Price'].values[0]

    webinardetail = {
        "StudentID": i,
        "WebinarID": webinar_id,
        "TerminationDate": (pd.to_datetime(date) + pd.DateOffset(days=30)).strftime('%Y-%m-%d %H:%M:%S')
    }
    webinardetails.append(webinardetail)

    ordermeeting = {
        "OrderContentID": i,
        "MeetingID": academic_meeting_id
    }
    orderacademicmeetings.append(ordermeeting)

    to_pay += AcademicMeeting.query('MeetingID == @academic_meeting_id')['UnitPrice'].values[0]

    if (not StationaryMeeting.query('MeetingID == @academic_meeting_id').empty) or (not OnlineSyncMeeting.query('MeetingID == @academic_meeting_id').empty):
        meetingatt = {
            "MeetingID": academic_meeting_id,
            "StudentID": i,
            "MeetingCompletion": state
        }
        meetingattendance.append(meetingatt)
    if academic_meeting_id > 120: # spotkanie hybrydowe
        hybrid_meeting = HybridMeetings.query('HybridMeetingID == @academic_meeting_id')
        component_meeting_ids = hybrid_meeting['ComponentMeetingID'].tolist()
        for component_meeting_id in component_meeting_ids:
            if (not StationaryMeeting.query('MeetingID == @component_meeting_id').empty) or (not OnlineSyncMeeting.query('MeetingID == @component_meeting_id').empty):
                meetingatt = {
                    "MeetingID": academic_meeting_id,
                    "StudentID": i,
                    "MeetingCompletion": state
                }
                meetingattendance.append(meetingatt)

    ordercourse = {
        "OrderContentID": i,
        "CourseID": course_id
    }

    ordercourses.append(ordercourse)

    to_pay += Courses.query('CourseID == @course_id')['Price'].values[0]

    coursestudentdet = {
        "StudentID": i,
        "CourseID": course_id,
        "Completed": state
    }
    coursestudentdetails.append(coursestudentdet)

    course_modules = CourseModules.query('CourseID == @course_id')
    for _, module in course_modules.iterrows():
        module_id = module['ModuleID']
        if not StationaryModule.query('ModuleID == @module_id').empty or not OnlineSyncModule.query('ModuleID == @module_id').empty:
            module_att = {
                "ModuleID": module_id,
                "StudentID": i,
                "ModuleCompletion": state
            }
            moduleattendance.append(module_att)
        if module_id > 40: # moduł hybrydowy
            hybrid_module = HybridModules.query('HybridModuleID == @module_id')
            component_module_ids = hybrid_module['ComponentModuleID'].tolist()
            for component_module_id in component_module_ids:
                if not StationaryModule.query('ModuleID == @component_module_id').empty or not OnlineSyncModule.query('ModuleID == @component_module_id').empty:
                    module_att = {
                        "ModuleID": component_module_id,
                        "StudentID": i,
                        "ModuleCompletion": state
                    }
                    moduleattendance.append(module_att)

    study = {
        "OrderContentID": i,
        "StudiesID": studies_id
    }
    orderstudies.append(study)

    to_pay += Studies.query('StudiesID == @studies_id')['Tuition'].values[0]

    studentdetail = {
        "StudentID": i,
        "StudiesID": studies_id,
        "Grade": None if not state else random.choice([3.0, 3.5, 4.0, 4.5, 5.0])
    }
    studentstudiesdetails.append(studentdetail)

    subject_ids = Subjects.query('StudiesID == @studies_id')['SubjectID'].tolist()
    for subject_id in subject_ids:
        subject_detail = {
            "StudentID": i, 
            "SubjectID": subject_id,
            "Grade": None if not state else random.choice([3.0, 3.5, 4.0, 4.5, 5.0])
        }
        StudentSubjectDetails.append(subject_detail)
        meeting_ids = AcademicMeeting.query('SubjectID == @subject_id')['MeetingID'].tolist()
        for meeting_id in meeting_ids:
            if (not StationaryMeeting.query('MeetingID == @meeting_id').empty) or (not OnlineSyncMeeting.query('MeetingID == @meeting_id').empty):
                meetingatt = {
                    "MeetingID": meeting_id,
                    "StudentID": i,
                    "MeetingCompletion": state
                }
                meetingattendance.append(meetingatt)
            if meeting_id > 120: # spotkanie hybrydowe
                hybrid_meeting = HybridMeetings.query('HybridMeetingID == @meeting_id')
                component_meeting_ids = hybrid_meeting['ComponentMeetingID'].tolist()
                for component_meeting_id in component_meeting_ids:
                    if (not StationaryMeeting.query('MeetingID == @component_meeting_id').empty) or (not OnlineSyncMeeting.query('MeetingID == @component_meeting_id').empty):
                        meetingatt = {
                            "MeetingID": component_meeting_id,
                            "StudentID": i,
                            "MeetingCompletion": state
                        }
                        meetingattendance.append(meetingatt)

    student_internship = {
        "InternshipID": random.choice([2*studies_id - 1, 2*studies_id]),
        "StudentID": i,
        "CompletedDays": 14 if state else 0
    }
    StudentInternshipDetails.append(student_internship)

    # na sam koniec
    payment = {
        "PaymentID": i,
        "PaidAmount": round(to_pay * 1.23, 2), # doliczenie VATu i zaokrąglenie do 2 miejsc po przecinku
        "OrderID": i,
        "PaymentDate": date
    }
    payments.append(payment)

orders_df = pd.DataFrame(orders)
ordercontentdetails_df = pd.DataFrame(ordercontentdetails)
order_webinars_df = pd.DataFrame(order_webinars)
webinardetails_df = pd.DataFrame(webinardetails)
payments_df = pd.DataFrame(payments)
orderacademicmeetings_df = pd.DataFrame(orderacademicmeetings)
meetingattendance_df = pd.DataFrame(meetingattendance)
ordercourses_df = pd.DataFrame(ordercourses)
coursestudentdetails_df = pd.DataFrame(coursestudentdetails)
moduleattendance_df = pd.DataFrame(moduleattendance)
orderstudies_df = pd.DataFrame(orderstudies)
studentstudiesdetails_df = pd.DataFrame(studentstudiesdetails)
StudentSubjectDetails_df = pd.DataFrame(StudentSubjectDetails)
StudentInternshipDetails_df = pd.DataFrame(StudentInternshipDetails)

orders_df.to_csv('Orders.csv', index=False)
ordercontentdetails_df.to_csv('OrderContentDetails.csv', index=False)
order_webinars_df.to_csv('OrderWebinar.csv', index=False)
webinardetails_df.to_csv('WebinarDetails.csv', index=False)
payments_df.to_csv('Payments.csv', index=False)
orderacademicmeetings_df.to_csv('OrderAcademicMeeting.csv', index=False)
meetingattendance_df.to_csv('MeetingAttendance.csv', index=False)
ordercourses_df.to_csv('OrderCourse.csv', index=False)
coursestudentdetails_df.to_csv('CourseStudentDetails.csv', index=False)
moduleattendance_df.to_csv('ModuleAttendance.csv', index=False)
orderstudies_df.to_csv("OrderStudies.csv", index=False)
studentstudiesdetails_df.to_csv('StudentStudiesDetails.csv', index=False)
StudentSubjectDetails_df.to_csv('StudentSubjectDetails.csv', index=False)
StudentInternshipDetails_df.to_csv('StudentInternshipDetails.csv', index=False)