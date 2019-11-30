Feature: Signout

  Scenario: Should sign out
    Given I expect to be in "TalksPage"
    When I signout
    Then I expect to be in "LogInPage"