import pandas as pd
from faker import Faker
import random

# Initialize Faker with Polish locale
fake = Faker('pl_PL')

# Define the number of records to generate
num_records = 15

# Generate studies records
studies = []
for i in range(1, num_records + 1):
    study = {
        'StudiesID': i,
        'StudiesName': fake.unique.word().capitalize(),
        'Syllabus': fake.text(max_nb_chars=200),
        'Tuition': round(random.uniform(5000, 10000), 2)
    }
    studies.append(study)

# Convert the list of dictionaries to a DataFrame
studies_df = pd.DataFrame(studies)

# Save the DataFrame to a CSV file
studies_df.to_csv('Studies.csv', index=False)

print(f'{num_records} studies records have been written to Studies.csv')