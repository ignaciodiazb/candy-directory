require "application_system_test_case"

class CandySearchTest < ApplicationSystemTestCase
  test "typing in the search field filters results without full reload" do
    visit candies_path
    assert_selector ".candy-card", text: "Super Ocho"
    assert_selector ".candy-card", text: "Mentita"

    fill_in "Buscar", with: "Super"

    assert_selector "#candies_results .candy-card", text: "Super Ocho"
    assert_no_selector "#candies_results .candy-card", text: "Mentita"
    assert_current_path(/q=Super/)
  end
end
