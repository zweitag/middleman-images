Feature: Ignore original

  Scenario: Build original when processing
    Given a fixture app "image"
    And our extension is enabled with:
      """
      config.ignore_original = false
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path '/images/fox.jpg', optimize: true %>
      """
    And the Server is running
    And I go to "/index.html"
    When I go to "/images/fox.jpg"
    Then the status code should be "200"

  Scenario: Ignore original when processing
    Given a fixture app "image"
    And our extension is enabled with:
      """
      config.ignore_original = true
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path 'fox.jpg', optimize: true %>
      """
    And the Server is running
    And I go to "/index.html"
    When I go to "/images/fox.jpg"
    Then the status code should be "404"

  Scenario: Build original when not processing
    Given a fixture app "image"
    And our extension is enabled with:
      """
      config.ignore_original = true
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path 'fox.jpg', optimize: false %>
      """
    And the Server is running
    And I go to "/index.html"
    When I go to "/images/fox.jpg"
    Then the status code should be "200"

  Scenario: Build original when using processed before original image
    Given a fixture app "image"
    And our extension is enabled with:
      """
      config.ignore_original = true
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path 'fox.jpg', optimize: true %>
      <%= image_path 'fox.jpg', optimize: false %>
      """
    And the Server is running
    And I go to "/index.html"
    When I go to "/images/fox.jpg"
    Then the status code should be "200"

  Scenario: Build original when using processed after original image
    Given a fixture app "image"
    And our extension is enabled with:
      """
      config.ignore_original = true
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path 'fox.jpg', optimize: false %>
      <%= image_path 'fox.jpg', optimize: true %>
      """
    And the Server is running
    And I go to "/index.html"
    When I go to "/images/fox.jpg"
    Then the status code should be "200"
