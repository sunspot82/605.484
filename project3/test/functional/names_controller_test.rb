require 'test_helper'

class NamesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:names)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create name" do
    assert_difference('Name.count') do
      post :create, :name => { }
    end

    assert_redirected_to name_path(assigns(:name))
  end

  test "should show name" do
    get :show, :id => names(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => names(:one).to_param
    assert_response :success
  end

  test "should update name" do
    put :update, :id => names(:one).to_param, :name => { }
    assert_redirected_to name_path(assigns(:name))
  end

  test "should destroy name" do
    assert_difference('Name.count', -1) do
      delete :destroy, :id => names(:one).to_param
    end

    assert_redirected_to names_path
  end
end
