from flask import Flask, jsonify, request
import logging
import random
import time

app = Flask(__name__)

# Configure logging
logging.basicConfig(filename='star_wars.log', level=logging.INFO)

# In-memory database of people planets starships
people = [
    {'id': 1, 'name': 'Luke Skywalker','height': '172','mass': '77','hair_color': 'blond'},
    {'id': 2, 'name': 'C-3PO','height': '165','mass': '75','hair_color': 'none'}
]

planets = [
    {'id': 1, 'name': 'Tatooine','rotation_period': '23','orbital_period': '304'},
    {'id': 2, 'name': 'Alderaan','rotation_period': '24','orbital_period': '364'}
]

starships = [
    {'id': 1, 'name': 'CR90 corvette','model': 'CR90 corvette','manufacturer': 'Corellian Engineering Corporation'},
    {'id': 2, 'name': 'Star Destroyer','model': 'Imperial I-class Star Destroyer','manufacturer': 'Kuat Drive Yards'}
]

def random_delay():
    time.sleep(random.uniform(0.5, 2))

# Welcome message
@app.route('/')
def welcome():
    return 'Welcome to the Star Wars Web API!'

# Read
@app.route('/people', methods=['GET'])
def get_all_people():
    random_delay()
    logging.info('Incoming request: {request.method} {request.path}, Response code: 200')
    return jsonify(people)

@app.route('/planets', methods=['GET'])
def get_all_planets():
    random_delay()
    logging.info('Incoming request: {request.method} {request.path}, Response code: 200')
    return jsonify(planets)

@app.route('/starships', methods=['GET'])
def get_all_starships():
    random_delay()
    logging.info('Incoming request: {request.method} {request.path}, Response code: 200')
    return jsonify(starships)

@app.route('/people/<int:id>', methods=['GET'])
def get_people(id):
    random_delay()
    person = next((p for p in people if p['id'] == int(id)), None)
    if person:
        logging.info('Incoming request: {request.method} {request.path}, Response code: 200')
        return jsonify(person)
    else:
        logging.info('Incoming request: {request.method} {request.path}, Response code: 404')
        return jsonify({'error': 'Person with id {} not found'.format(id)}), 404

@app.route('/planets/<int:id>', methods=['GET'])
def get_planets(id):
    random_delay()
    planet = next((p for p in planets if p['id'] == int(id)), None)
    if planet:
        logging.info('Incoming request: {request.method} {request.path}, Response code: 200')
        return jsonify(planet)
    else:
        logging.info('Incoming request: {request.method} {request.path}, Response code: 404')
        return jsonify({'error': 'Planet with id {} not found'.format(id)}), 404

@app.route('/starships/<int:id>', methods=['GET'])
def get_starships(id):
    random_delay()
    starship = next((s for s in starships if s['id'] == int(id)), None)
    if starship:
        logging.info('Incoming request: {request.method} {request.path}, Response code: 200')
        return jsonify(starship)
    else:
        logging.info('Incoming request: {request.method} {request.path}, Response code: 404')
        return jsonify({'error': 'Starship with id {} not found'.format(id)}), 404
