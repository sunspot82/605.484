require 'test_helper'

class ProjectScopesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_scopes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_scope" do
    assert_difference('ProjectScope.count') do
      post :create, :project_scope => { }
    end

    assert_redirected_to project_scope_path(assigns(:project_scope))
  end

  test "should show project_scope" do
    get :show, :id => project_scopes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => project_scopes(:one).to_param
    assert_response :success
  end

  test "should update project_scope" do
    put :update, :id => project_scopes(:one).to_param, :project_scope => { }
    assert_redirected_to project_scope_path(assigns(:project_scope))
  end

  test "should destroy project_scope" do
    assert_difference('ProjectScope.count', -1) do
      delete :destroy, :id => project_scopes(:one).to_param
    end

    assert_redirected_to project_scopes_path
  end
end
