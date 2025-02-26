import csv
from faker import Faker
import random

# Initialize Faker
fake = Faker()
fake_pl = Faker('pl_PL')

# Define the number of records to generate
num_records = 300
num_polish_students = int(num_records * 0.8)  # 80% Polish students

# Define the CSV file name
csv_file = 'students.csv'

# Define the header for the CSV file
header = ['StudentID', 'FirstName', 'LastName', 'Address', 'City', 'PostalCode', 'Country', 'Email', 'PhoneNumber', 'IsRegularCustomer', 'GDPRAgreementDate']

# Function to generate a valid phone number
def generate_phone_number(fake, country_code):
    if country_code == '+48':
        return f'+48{random.randint(100000000, 999999999)}'
    else:
        return f'+{random.randint(10, 99)}{random.randint(100000000, 999999999)}'

# Generate student records
students = []
for i in range(1, num_records + 1):
    if i <= num_polish_students:
        fake = fake_pl
        country = 'Poland'
        phone_number = generate_phone_number(fake, '+48')
    else:
        fake = Faker()
        country = fake.country()
        phone_number = generate_phone_number(fake, f'+{random.randint(10, 99)}')

    student = {
        'StudentID': i,
        'FirstName': fake.first_name(),
        'LastName': fake.last_name(),
        'Address': fake.street_address(),
        'City': fake.city(),
        'PostalCode': fake.postcode(),
        'Country': country,
        'Email': fake.email(),
        'PhoneNumber': phone_number,
        'IsRegularCustomer': fake.boolean(),
        'GDPRAgreementDate': fake.date_time_this_decade().strftime('%Y-%m-%d %H:%M:%S')
    }
    students.append(student)

# Write the records to a CSV file
with open(csv_file, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=header)
    writer.writeheader()
    writer.writerows(students)

print(f'{num_records} student records have been written to {csv_file}')