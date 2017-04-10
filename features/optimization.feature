Feature: Image optimization

  Scenario: regular image_tag behavior without optimization
    Given a fixture app "image_tag"
    And a file named "source/index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: "Lazy Fox" %>
      """
    And a file named "config.rb" with:
      """
      activate :images, optimize: false
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox.jpg" alt="Lazy Fox" />'
    When I go to "/images/fox.jpg"
    Then the status code should be "200"
    And the content length should be equal to the file size of "source/images/fox.jpg"

  Scenario: Optimize an image by default
    Given a fixture app "image_tag"
    Given a file named "source/index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: 'Lazy Fox' %>
      """
    And a file named "config.rb" with:
      """
      activate :images
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox-opt.jpg" alt="Lazy Fox" />'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"
    And the content length should be smaller than the file size of "source/images/fox.jpg"

  Scenario: Override optimize by default
    Given a fixture app "image_tag"
    Given a file named "source/index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: 'Lazy Fox', optimize: false %>
      """
    And a file named "config.rb" with:
      """
      activate :images
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox.jpg" alt="Lazy Fox" />'

  Scenario: Override disabled optimization
    Given a fixture app "image_tag"
    Given a file named "source/index.html.erb" with:
      """
      <%= image_tag '/images/fox.jpg', alt: 'Lazy Fox', optimize: true %>
      """
    And a file named "config.rb" with:
      """
      activate :images, optimize: false
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/images/fox-opt.jpg" alt="Lazy Fox" />'
