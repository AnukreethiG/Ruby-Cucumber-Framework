@ey_corp_merch_site
Feature: Login Corp shopping site

    #Value input to text box
  Scenario Outline: Adding the first search result product to cart
    Given I launch Ey Corp Merchandise webpage
    And I search for the "<product>" in "Ey Merch"
    And I select the first <product> for test case <Test_Case>
    And I add the product to the cart
    And I validate the "Added to cart." message
    And I click on Cart icon and validate "<product>" is available in cart
    @add_a_product_to_cart
    Examples:
      | Test_Case | product |
      | Fst_01    | Bag     |
      | Fst_01    | Pen     |

  Scenario Outline: Adding the least price search result product to cart
    Given I launch Ey Corp Merchandise webpage
    And I search for the "<product>" in "Ey Merch"
    And I sort the product from lowest price and select the <product> for test case <Test_case>
    And I add the product to the cart
    And I validate the "Added to cart." message
    And I click on Cart icon and validate "<product>" is available in cart
    @least_product_to_cart
    Examples:
      | Test_case | product |
      | Lwt_01    | Bag     |
      | Lwt_02    | Pen     |

  Scenario Outline: Adding the highest price search result product to cart
    Given I launch Ey Corp Merchandise webpage
    And I search for the "<product>" in "Ey Merch"
    And I sort the product from highest price and select the <product> for test case <Test_case>
    And I add the product to the cart
    And I validate the "Added to cart." message
    And I click on Cart icon and validate "<product>" is available in cart
    @highest_product_to_cart
    Examples:
      | Test_case | product |
      | Hgh_01    | Bag     |
      | Hgh_02    | Pen     |

  Scenario Outline: Removing all product from cart
    Given I launch Ey Corp Merchandise webpage
    And I search for the "<product>" in "Ey Merch"
    And I select the first <product> for test case <Test_case>
    And I add the product to the cart
    And I validate the "Added to cart." message
    And I click on Cart icon and validate "<product>" is available in cart
    And I click on remove all from cart
    And I validate no item available in cart
    @remove_product
    Examples:
      | Test_case   | product |
      | Frst_rmv_01 | Bag     |
      | Frst_rmv_02 | Pen     |

  Scenario Outline: Add multiple product to the cart and validate the cost
    Given I launch Ey Corp Merchandise webpage
    And I add multiple <products> to the cart and capture the price of each product for test case <Test_Case>
    And I validate <products> subtotal in the cart
    @search_and_add_multiple_product
    Examples:
      | Test_Case | products     |
      | Mltp_01   | Bag, Pen     |
      | Mltp_02   | Book, Bottle |