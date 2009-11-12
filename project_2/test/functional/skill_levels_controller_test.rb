require 'test_helper'

class SkillLevelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:skill_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create skill_level" do
    assert_difference('SkillLevel.count') do
      post :create, :skill_level => { }
    end

    assert_redirected_to skill_level_path(assigns(:skill_level))
  end

  test "should show skill_level" do
    get :show, :id => skill_levels(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => skill_levels(:one).to_param
    assert_response :success
  end

  test "should update skill_level" do
    put :update, :id => skill_levels(:one).to_param, :skill_level => { }
    assert_redirected_to skill_level_path(assigns(:skill_level))
  end

  test "should destroy skill_level" do
    assert_difference('SkillLevel.count', -1) do
      delete :destroy, :id => skill_levels(:one).to_param
    end

    assert_redirected_to skill_levels_path
  end
end
