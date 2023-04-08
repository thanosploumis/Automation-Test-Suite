# Automation-Test-Suite

Target Platform: Windows

Task #1: Functional test suite
1) Create a fake http server in Python with API that behaves
similar to https://swapi.dev/
It should support the same three end-points (people/xx/,
planets/xx/, starships/xx/)
and can always return the same json response for any id passed.
For some specific ids e.g. &gt;100 should return a 404 Not Found
error with a json body that describes the problem.
The server should keep a log file that logs all the incoming
requested URLs and response codes.

2) Create an automated test suite (using test framework like Robot
Framework) that:
a) prepares the test environment by starting the http server
b) runs test cases per end-point that verify both happy path
(sends back a valid json response with the expected values)
or edge cases (e.g. id not found)
c) shuts down the environment
d) prints out the test execution results to the console

Task #2: Performance test suite

3) Extend the http server to incur a random small delay per http
request.

4) Create a performance test suite that:
a) prepares the test environment by starting the http server
b) accesses one of the end-points continuously for a time
duration e.g. 1 minute (sequential access is fine)
c) for each access it keeps track of the response time on the
client side
d) shuts down the environment
e) prints out mean &amp; standard deviation of the response time
for the end-point
