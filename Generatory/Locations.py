import csv
from faker import Faker
import random

# Initialize Faker
fake = Faker('pl_PL')

# Define the number of records to generate
num_records = 50

# Define the CSV file name
csv_file = 'locations.csv'

# Define the header for the CSV file
header = ['LocationID', 'Address', 'Room', 'MaxPeople']

# Define the city for all addresses
city = 'Kraków'

# Generate location records
locations = []
for i in range(1, num_records + 1):
    address = f'{fake.street_address()}, {city}'
    location = {
        'LocationID': i,
        'Address': address,
        'Room': fake.bothify(text='###?'),
        'MaxPeople': random.randint(10, 100)
    }
    locations.append(location)

# Write the records to a CSV file
with open(csv_file, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=header)
    writer.writeheader()
    writer.writerows(locations)

print(f'{num_records} location records have been written to {csv_file}')