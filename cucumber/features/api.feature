@api
Feature: Smoke Test
  In order to test the deployment
  I want to validate the status endpoint

  Scenario: retrieve the status endpoint
    When I GET the path "/"
    Then the response should be 200
    And the result should contain "Hello World"
