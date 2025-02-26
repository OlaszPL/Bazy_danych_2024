import pandas as pd
from faker import Faker
import random

# Initialize Faker
fake = Faker('pl_PL')

# Read the CSV files into DataFrames
languages_df = pd.read_csv('Languages.csv')
translator_language_details_df = pd.read_csv('TranslatorLanguageDetails.csv')

# Define the number of records to generate
num_modules = 40
num_courses = 15

# Function to get a random translator for a given language
def get_translator_id(language_id):
    translators = translator_language_details_df[translator_language_details_df['LanguageID'] == language_id]
    if not translators.empty:
        return int(translators.sample(1).iloc[0]['TranslatorID'])
    return None

# Generate course module records
course_modules = []
stationary_modules = []
online_sync_modules = []
online_async_modules = []
hybrid_modules = []

for i in range(1, num_modules + 1):
    course_id = random.randint(1, num_courses)
    language = languages_df.sample(1).iloc[0]
    language_id = int(language['LanguageID'])
    translator_id = None
    if language_id != 2:
        translator_id = get_translator_id(language_id)
    
    module = {
        'ModuleID': i,
        'ModuleName': fake.sentence(nb_words=4),
        'CourseID': course_id,
        'LanguageID': language_id,
        'TeacherID': random.randint(1, 50),
        'TranslatorID': translator_id,
        'Date': fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S')
    }
    course_modules.append(module)
    
    # Randomly assign the module to one of the types
    module_type = random.choice(['Stationary', 'OnlineSync', 'OnlineAsync'])
    if module_type == 'Stationary':
        stationary_modules.append({'ModuleID': i, 'LocationID': random.randint(1, 10)})
    elif module_type == 'OnlineSync':
        online_sync_modules.append({'ModuleID': i, 'Link': fake.uri()})
    elif module_type == 'OnlineAsync':
        online_async_modules.append({'ModuleID': i, 'VideoLink': fake.uri()})

# Create some hybrid modules
num_hybrid_modules = 10
for i in range(1, num_hybrid_modules + 1):
    hybrid_module_id = num_modules + i
    for _ in range(random.randint(2, 4)):
        component_module_id = random.randint(1, num_modules)
        hybrid_modules.append({'HybridModuleID': hybrid_module_id, 'ComponentModuleID': component_module_id})

    course_modules.append({
            'ModuleID': hybrid_module_id,
            'ModuleName': fake.sentence(nb_words=4),
            'CourseID': random.randint(1, num_courses),
            'LanguageID': random.choice(languages_df['LanguageID'].tolist()),
            'TeacherID': random.randint(1, 50),
            'TranslatorID': None,
            'Date': fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S')
        })

# Convert the lists of dictionaries to DataFrames
course_modules_df = pd.DataFrame(course_modules)
stationary_modules_df = pd.DataFrame(stationary_modules)
online_sync_modules_df = pd.DataFrame(online_sync_modules)
online_async_modules_df = pd.DataFrame(online_async_modules)
hybrid_modules_df = pd.DataFrame(hybrid_modules)

# Save the DataFrames to CSV files
course_modules_df.to_csv('CourseModules.csv', index=False)
stationary_modules_df.to_csv('StationaryModule.csv', index=False)
online_sync_modules_df.to_csv('OnlineSyncModule.csv', index=False)
online_async_modules_df.to_csv('OnlineAsyncModule.csv', index=False)
hybrid_modules_df.to_csv('HybridModules.csv', index=False)

print(f'{num_modules} course module records have been written to CourseModules.csv')
print(f'{len(stationary_modules)} stationary module records have been written to StationaryModule.csv')
print(f'{len(online_sync_modules)} online sync module records have been written to OnlineSyncModule.csv')
print(f'{len(online_async_modules)} online async module records have been written to OnlineAsyncModule.csv')
print(f'{num_hybrid_modules} hybrid module records have been written to HybridModules.csv')