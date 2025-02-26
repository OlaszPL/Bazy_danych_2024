import pandas as pd
from faker import Faker
import random

# Initialize Faker with Polish locale
fake = Faker('pl_PL')

# Read the CSV files into DataFrames
languages_df = pd.read_csv('Languages.csv')
translator_language_details_df = pd.read_csv('TranslatorLanguageDetails.csv')

# Define the number of subjects and meetings
num_subjects = 60
num_meetings_per_subject = 2

# Function to get a random translator for a given language
def get_translator_id(language_id):
    translators = translator_language_details_df[translator_language_details_df['LanguageID'] == language_id]
    if not translators.empty:
        return int(translators.sample(1).iloc[0]['TranslatorID'])
    return None

# Generate academic meeting records
academic_meetings = []
online_async_meetings = []
online_sync_meetings = []
stationary_meetings = []
hybrid_meetings = []

for subject_id in range(1, num_subjects + 1):
    for _ in range(num_meetings_per_subject):
        meeting_id = len(academic_meetings) + 1
        # Ensure most meetings are in Polish
        if random.random() < 0.7:
            language_id = 2
        else:
            language = languages_df.sample(1).iloc[0]
            language_id = int(language['LanguageID'])

        translator_id = None if language_id == 2 else get_translator_id(language_id)

        meeting = {
            'MeetingID': meeting_id,
            'MeetingName': fake.sentence(nb_words=4),
            'SubjectID': subject_id,
            'Date': fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S'),
            'TeacherID': random.randint(1, 50),
            'TranslatorID': translator_id,
            'LanguageID': language_id,
            'UnitPrice': round(random.uniform(100, 1000), 2)
        }
        academic_meetings.append(meeting)

        # Randomly assign the meeting to one of the types
        meeting_type = random.choice(['Stationary', 'OnlineSync', 'OnlineAsync'])
        if meeting_type == 'Stationary':
            stationary_meetings.append({'MeetingID': meeting_id, 'LocationID': random.randint(1, 10)})
        elif meeting_type == 'OnlineSync':
            online_sync_meetings.append({'MeetingID': meeting_id, 'Link': fake.uri()})
        elif meeting_type == 'OnlineAsync':
            online_async_meetings.append({'MeetingID': meeting_id, 'VideoLink': fake.uri()})

# Create some hybrid meetings
num_hybrid_meetings = 10
for i in range(1, num_hybrid_meetings + 1):
    hybrid_meeting_id = len(academic_meetings) + i
    for _ in range(random.randint(2, 4)):
        component_meeting_id = random.randint(1, len(academic_meetings))
        hybrid_meetings.append({'HybridMeetingID': hybrid_meeting_id, 'ComponentMeetingID': component_meeting_id})

    academic_meetings.append({
        'MeetingID': hybrid_meeting_id,
        'MeetingName': fake.sentence(nb_words=4),
        'SubjectID': random.randint(1, num_subjects),
        'Date': fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S'),
        'TeacherID': random.randint(1, 50),
        'TranslatorID': None,
        'LanguageID': 2,
        'UnitPrice': round(random.uniform(100, 1000), 2)
    })

# Convert the lists of dictionaries to DataFrames
academic_meetings_df = pd.DataFrame(academic_meetings)
stationary_meetings_df = pd.DataFrame(stationary_meetings)
online_sync_meetings_df = pd.DataFrame(online_sync_meetings)
online_async_meetings_df = pd.DataFrame(online_async_meetings)
hybrid_meetings_df = pd.DataFrame(hybrid_meetings)

# Save the DataFrames to CSV files
academic_meetings_df.to_csv('AcademicMeeting.csv', index=False)
stationary_meetings_df.to_csv('StationaryMeeting.csv', index=False)
online_sync_meetings_df.to_csv('OnlineSyncMeeting.csv', index=False)
online_async_meetings_df.to_csv('OnlineAsyncMeeting.csv', index=False)
hybrid_meetings_df.to_csv('HybridMeetings.csv', index=False)

print(f'{len(academic_meetings)} academic meeting records have been written to AcademicMeeting.csv')
print(f'{len(stationary_meetings)} stationary meeting records have been written to StationaryMeeting.csv')
print(f'{len(online_sync_meetings)} online sync meeting records have been written to OnlineSyncMeeting.csv')
print(f'{len(online_async_meetings)} online async meeting records have been written to OnlineAsyncMeeting.csv')
print(f'{num_hybrid_meetings} hybrid meeting records have been written to HybridMeetings.csv')