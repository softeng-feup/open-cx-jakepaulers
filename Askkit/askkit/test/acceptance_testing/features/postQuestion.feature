Feature: Question

  Scenario: Should post question
    Given I expect the number of questions to be 0
    When I tap the "add question" button
    And I submit a question
    Then I expect the number of questions to be 1