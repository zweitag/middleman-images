Feature: images_dir configuration given

  Scenario: Building correctly
    Given a fixture app "image"
    And a middleman configuration with:
      """
      set :images_dir, 'assets/images'
      """
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_tag 'fox.jpg', optimize: true, resize: 400 %>
      """
    When a successfully built app at "image"
    When I cd to "build/assets/images"
    Then a file named "fox-400-opt.jpg" should exist

  Scenario: Running correctly
    Given a fixture app "image"
    And a middleman configuration with:
      """
      set :images_dir, 'assets/images'
      """
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_tag 'fox.jpg', optimize: true, resize: 400 %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '<img src="/assets/images/fox-400-opt.jpg" alt="Fox" />'
    When I go to "/assets/images/fox-400-opt.jpg"
    Then the status code should be "200"
