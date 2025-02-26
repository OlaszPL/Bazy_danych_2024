import csv
from faker import Faker
import random

# Initialize Faker
fake = Faker()
fake_pl = Faker('pl_PL')

# Define the number of records to generate
num_records = 50
num_polish_teachers = int(num_records * 0.8)  # 80% Polish teachers

# Define the CSV file name
csv_file = 'teachers.csv'

# Define the header for the CSV file
header = ['TeacherID', 'FirstName', 'LastName', 'Address', 'City', 'Country', 'Email', 'PhoneNumber']

# Function to generate a valid phone number
def generate_phone_number(country_code):
    if country_code == '+48':
        return f'+48{random.randint(100000000, 999999999)}'
    else:
        return f'+{random.randint(10, 99)}{random.randint(100000000, 999999999)}'

# Generate teacher records
teachers = []
for i in range(1, num_records + 1):
    if i <= num_polish_teachers:
        fake = fake_pl
        country = 'Poland'
        phone_number = generate_phone_number('+48')
    else:
        fake = Faker()
        country = fake.country()
        phone_number = generate_phone_number(f'+{random.randint(10, 99)}')

    teacher = {
        'TeacherID': i,
        'FirstName': fake.first_name(),
        'LastName': fake.last_name(),
        'Address': fake.street_address(),
        'City': fake.city(),
        'Country': country,
        'Email': fake.email(),
        'PhoneNumber': phone_number
    }
    teachers.append(teacher)

# Write the records to a CSV file
with open(csv_file, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=header)
    writer.writeheader()
    writer.writerows(teachers)

print(f'{num_records} teacher records have been written to {csv_file}')