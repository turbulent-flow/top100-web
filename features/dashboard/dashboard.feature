Feature: Dashboard Overview
    Users view the dashboard with the various devices, e.g., desktop, tablet.
    The response of the UI on the dashboard varies as the different size of the screen of the device.
    The screen size of the devices which are imitated by this process are listed below:
        | name            | size     |
        | desktop         | > 768px  |
        | portable device | <= 768px |   

    Background: 
        Given Top100Ranking filters '{"category_id":2, "page":1}' and return the following categories:
            | id | name                      |
            | 42 | Amazon Device Accessories |
            | 43 | Amazon Devices            |
        And also return the following products:
            | name                                                            | rank |
            | Echo Dot (3rd Gen) - Smart speaker with Alexa - Charcoal        | 1    |
            | Fire 7 Tablet (7\" display, 16 GB) - Black                      | 2    |
            | Fire HD 10 Tablet (10.1\" 1080p full HD display, 32 GB) – Black | 3    |
            | Echo (3rd Gen)- Smart speaker with Alexa- Charcoal              | 4    |
            | Ring Rechargeable Battery Pack                                  | 5    |

    Scenario: Viewing with the desktop
        When I nvaigate to the dashboard
        Then I should see the following categories:
            | name                      |
            | Amazon Device Accessories |
            | Amazon Devices            |
        And I should see the following products:
            | rank | name                                                            |
            | 1    | Echo Dot (3rd Gen) - Smart speaker with Alexa - Charcoal        |
            | 2    | Fire 7 Tablet (7\" display, 16 GB) - Black                      |
            | 3    | Fire HD 10 Tablet (10.1\" 1080p full HD display, 32 GB) – Black |
            | 4    | Echo (3rd Gen)- Smart speaker with Alexa- Charcoal              |
            | 5    | Ring Rechargeable Battery Pack                                  |
    
    Scenario: Viewing with the portable device, should not see any categories
        When I nvaigate to the dashboard with the portable device
        Then I should not see any categories
        And I should see the following products:
            | rank | name                                                            |
            | 1    | Echo Dot (3rd Gen) - Smart speaker with Alexa - Charcoal        |
            | 2    | Fire 7 Tablet (7\" display, 16 GB) - Black                      |
            | 3    | Fire HD 10 Tablet (10.1\" 1080p full HD display, 32 GB) – Black |
            | 4    | Echo (3rd Gen)- Smart speaker with Alexa- Charcoal              |
            | 5    | Ring Rechargeable Battery Pack                                  |
