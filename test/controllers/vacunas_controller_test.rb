require 'test_helper'

class VacunasControllerTest < ActionController::TestCase
  test "should get listar" do
    get :listar
    assert_response :success
  end

  test "should get solicitar" do
    get :solicitar
    assert_response :success
  end

  test "should get pagar" do
    get :pagar
    assert_response :success
  end

end
