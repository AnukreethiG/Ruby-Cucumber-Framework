Feature: Login Amazon site

  #Value input to text box
  Scenario Outline: Searching single product in Amazon
    Given I launch Amazon webpage
    And I search for the "<product>" in "Amazon"
    @Searching_a_product
    Examples:
      | product           |
      | Heritage Cow Ghee |
      | Mobile            |

      #Print Dropdown list
  @priniting_language_dropdown
  Scenario: Printing list of prefered language
    Given I launch Amazon webpage
    And I click on language dropdown
    And I print the available language option

  #Selecting a radio button
  Scenario Outline: Selecting preferred language using radio button
    Given I launch Amazon webpage
    And I click on language dropdown
    And I select the language <language>
    @selecting_preferred_language
    Examples:
      | language |
      | TA       |
      | KA       |
      | HI       |
