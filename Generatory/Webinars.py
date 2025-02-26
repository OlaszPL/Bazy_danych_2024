import pandas as pd
from faker import Faker
import random

# Initialize Faker
fake = Faker()
fake_pl = Faker('pl_PL')

# Read the CSV files into DataFrames
languages_df = pd.read_csv('Languages.csv')
translator_language_details_df = pd.read_csv('translator_language_details.csv')

# Define the number of records to generate
num_records = 40
num_polish_webinars = int(num_records * 0.8)  # 80% Polish webinars

# Function to get a random translator for a given language
def get_translator_id(language_id):
    translators = translator_language_details_df[translator_language_details_df['LanguageID'] == language_id]
    if not translators.empty:
        return int(translators.sample(1).iloc[0]['TranslatorID'])
    return None

# Generate webinar records
webinars = []
for i in range(1, num_records + 1):
    if i <= num_polish_webinars:
        fake = fake_pl
        language_id = random.choice([2, random.choice(languages_df['LanguageID'].tolist())])
        translator_id = None
        if language_id != 2:
            translator_id = get_translator_id(language_id)
    else:
        fake = Faker()
        language = languages_df.sample(1).iloc[0]
        language_id = int(language['LanguageID'])
        translator_id = None
        if language_id != 2:
            translator_id = get_translator_id(language_id)

    webinar = {
        'WebinarID': int(i),
        'WebinarName': fake.sentence(nb_words=4) if language_id != 2 else fake_pl.sentence(nb_words=4),  # Generate a meaningful name based on language
        'Price': round(random.choice([0, random.uniform(10, 100)]), 2),  # Some webinars can be free, round to 2 decimal places
        'TeacherID': int(random.randint(1, 50)),  # Assuming there are 50 teachers
        'Link': fake.uri(),  # Generate a more realistic link
        'TranslatorID': translator_id,
        'WebinarDate': fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S'),
        'LanguageID': language_id,
        'Description': fake.text(max_nb_chars=200)  # Generate a random Lorem Ipsum description
    }
    webinars.append(webinar)

# Convert the list of dictionaries to a DataFrame
webinars_df = pd.DataFrame(webinars)

# Ensure TranslatorID is either int or None
webinars_df['TranslatorID'] = webinars_df['TranslatorID'].astype('Int64')

# Save the DataFrame to a CSV file
webinars_df.to_csv('Webinars.csv', index=False)

print(f'{num_records} webinar records have been written to Webinars.csv')