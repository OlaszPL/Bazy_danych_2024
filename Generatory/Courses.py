import pandas as pd
from faker import Faker
import random

# Initialize Faker with Polish locale
fake = Faker()

# Define the number of records to generate
num_records = 15

# Generate course records
courses = []
for i in range(1, num_records + 1):
    course = {
        'CourseID': i,
        'CourseName': fake.unique.catch_phrase(),
        'Price': round(random.uniform(100, 1000), 2),
        'Description': fake.text(max_nb_chars=200)
    }
    courses.append(course)

# Convert the list of dictionaries to a DataFrame
courses_df = pd.DataFrame(courses)

# Save the DataFrame to a CSV file
courses_df.to_csv('Courses.csv', index=False)

print(f'{num_records} course records have been written to Courses.csv')