@departments
Feature: Suzie views a petition
  In order to read a petition and potentially sign it
  As Suzie the signer
  I want to view a petition of my choice from a list, seeing the vote count, closed and open dates, along with the reason for rejection if applicable

  Scenario: Suzie views an open petition
    Given an open petition "Spend more money on Defence" belonging to the "Treasury"
    When I view the petition
    Then I should see the petition details
    And I should see "Spend more money on Defence - e-petitions" in the browser page title
    And I should see the vote count, closed and open dates
    And I should not see "This e-petition is now closed"

  Scenario: Suzie views a petition containing urls, email addresses and html tags
    Given an open petition exists with title: "Defence review", description: "<i>We<i> like http://www.google.com and bambi@gmail.com"
    When I go to the petition page for "Defence review"
    # Cannot test for validity due to iframe attribute required for IE7
    # Then the markup should be valid
    And I should see "<i>We<i>"
    And I should see a link called "http://www.google.com" linking to "http://www.google.com"
    And I should see a link called "bambi@gmail.com" linking to "mailto:bambi@gmail.com"

  Scenario: Suzie sees reason for rejection if appropriate
    Given a petition "Please bring back Eldorado" has been rejected by the "Treasury" with the reason "<i>We<i> like http://www.google.com and bambi@gmail.com"
    When I view the petition
    Then I should see the petition details
    And I should see the reason for rejection
    And I should see "<i>We<i>"
    And I should see a link called "http://www.google.com" linking to "http://www.google.com"
    And I should see a link called "bambi@gmail.com" linking to "mailto:bambi@gmail.com"
    And I cannot sign the petition

  Scenario: Suzie cannot sign closed petition
    Given a petition "Spend more money on Defence" belonging to the "Treasury" has been closed
    When I view the petition
    Then I should see the petition details
    And I cannot sign the petition
    
  Scenario: Suzie sees a 'closed' message when viewing a closed petition
    Given a petition "Spend more money on Defence" belonging to the "Treasury" has been closed
    When I view the petition
    Then I should see "This e-petition is now closed"
