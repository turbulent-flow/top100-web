Feature: Dashoard - Overview

    Background:
        Given I have the following marketplace:
        And I have the following categories:
        And I have the following products:

    Scenario:
        When I navigate to the dashboard
        Then I should see the following categories:
        And I should see the following products
