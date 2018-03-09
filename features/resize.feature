Feature: Image resizing

  Scenario: Resize image
    Given a fixture app "image"
    And a template named "index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: "Lazy Fox", resize: "400x225", optimize: false %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox-400x225.jpg" alt="Lazy Fox" />'
    When I go to "/images/fox-400x225.jpg"
    Then the status code should be "200"
    And the dimensions should be 400x225

  Scenario: Resize image with optimization
    Given a fixture app "image"
    And a template named "index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: "Lazy Fox", resize: "400x225", optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox-400x225-opt.jpg" alt="Lazy Fox" />'
    When I go to "/images/fox-400x225-opt.jpg"
    Then the status code should be "200"
    And the dimensions should be 400x225
