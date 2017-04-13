Feature: All image helpers optimize and resize

  Scenario: image_path
    Given a fixture app "image"
    And "images" feature is "enabled"
    And a template named "index.html.erb" with:
      """
      <%= image_path '/images/fox.jpg', resize: "400x225", optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/images/fox-400x225-opt.jpg'
    When I go to "/images/fox-400x225-opt.jpg"
    Then the status code should be "200"

  Scenario: image_url
    Given a fixture app "image"
    And "images" feature is "enabled"
    And a template named "index.html.erb" with:
      """
      <%= image_url '/images/fox.jpg', resize: "400x225", optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see 'http://www.example.org/images/fox-400x225-opt.jpg'
    When I go to "/images/fox-400x225-opt.jpg"
    Then the status code should be "200"
