import csv
from faker import Faker
import random

# Initialize Faker
fake = Faker()
fake_pl = Faker('pl_PL')

# Define the number of records to generate
num_records = 30
num_polish_translators = num_records // 2  # 50% Polish translators

# Define the CSV file names
translators_csv = 'translators.csv'
translator_language_details_csv = 'translator_language_details.csv'

# Define the headers for the CSV files
translators_header = ['TranslatorID', 'FirstName', 'LastName', 'Email', 'PhoneNumber']
translator_language_details_header = ['TranslatorID', 'LanguageID']

# Function to generate a valid phone number
def generate_phone_number(country_code):
    if country_code == '+48':
        return f'+48{random.randint(100000000, 999999999)}'
    else:
        return f'+{random.randint(10, 99)}{random.randint(100000000, 999999999)}'

# Generate translator records
translators = []
translator_language_details = []
for i in range(1, num_records + 1):
    if i <= num_polish_translators:
        fake = fake_pl
        country_code = '+48'
        language_id = 2  # Polish language ID
    else:
        fake = Faker()
        country_code = f'+{random.randint(10, 99)}'
        language_id = random.randint(1, 30)  # Random language ID for non-Polish translators

    phone_number = generate_phone_number(country_code)
    translator = {
        'TranslatorID': i,
        'FirstName': fake.first_name(),
        'LastName': fake.last_name(),
        'Email': fake.email(),
        'PhoneNumber': phone_number
    }
    translators.append(translator)

    # Add native language
    translator_language_details.append({'TranslatorID': i, 'LanguageID': language_id})

    # Add 1 to 3 additional languages
    additional_languages = random.sample(range(1, 31), random.randint(1, 3))
    for lang_id in additional_languages:
        if lang_id != language_id:  # Avoid duplicating the native language
            translator_language_details.append({'TranslatorID': i, 'LanguageID': lang_id})

# Write the translator records to a CSV file
with open(translators_csv, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=translators_header)
    writer.writeheader()
    writer.writerows(translators)

# Write the translator language details to a CSV file
with open(translator_language_details_csv, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=translator_language_details_header)
    writer.writeheader()
    writer.writerows(translator_language_details)

print(f'{num_records} translator records have been written to {translators_csv}')
print(f'Translator language details have been written to {translator_language_details_csv}')