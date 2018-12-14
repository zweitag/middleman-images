Feature: Relative paths

  Scenario: Absolute image path 
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_path '/images/fox.jpg', optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see 'images/fox-opt.jpg'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"

  Scenario: Relative image path
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_path 'fox.jpg', optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see 'images/fox-opt.jpg'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"

  Scenario: Relative asset path
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_path 'images/fox.jpg', optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see 'images/fox-opt.jpg'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"
