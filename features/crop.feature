Feature: Image cropping

  Scenario: Cropping an image
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: "Lazy Fox", crop: "413x123!+0+0", optimize: false, gravity: 'Center' %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox-413x123_0_0.jpg" alt="Lazy Fox" />'
    When I go to "/images/fox-413x123_0_0.jpg"
    Then the status code should be "200"
    And the dimensions should be 413x123

  Scenario: Cropping an image with optimization
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: "Lazy Fox", crop: "413x123!+0+0", optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox-413x123_0_0-opt.jpg" alt="Lazy Fox" />'
    When I go to "/images/fox-413x123_0_0-opt.jpg"
    Then the status code should be "200"
    And the dimensions should be 413x123
