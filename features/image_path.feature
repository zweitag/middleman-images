Feature: All image helpers optimize and resize

  Scenario: image_path with options
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

  Scenario: image_path without options
    Given a fixture app "image"
    And "images" feature is "enabled"
    And a template named "index.html.erb" with:
      """
      <%= image_path '/images/fox.jpg' %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/images/fox-opt.jpg'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"

  Scenario: image_path with unavailable image file
    Given a fixture app "image"
    And "images" feature is "enabled"
    And a template named "index.html.erb" with:
      """
      <%= image_path 'nofile.jpg' %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/images/nofile.jpg'
    When I go to "/images/nofile.jpg"
    Then the status code should be "404"

  Scenario: image_path with relative image path
    Given a fixture app "image"
    And "images" feature is "enabled"
    And a template named "index.html.erb" with:
      """
      <%= image_path 'fox.jpg' %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see 'images/fox-opt.jpg'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"

  Scenario: image_path with changed image_dir
    Given a fixture app "image"
    And "images" feature is "enabled"
    And "images_dir" is set to "assets/images"
    And a template named "index.html.erb" with:
      """
      <%= image_path 'fox.jpg' %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see 'assets/images/fox-opt.jpg'
    When I go to "/assets/images/fox-opt.jpg"
    Then the status code should be "200"
