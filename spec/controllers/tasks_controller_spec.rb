require 'spec_helper'

describe TasksController do

  let(:task) { tasks(:create_enterprise) }

  before(:each) do
    login!
  end

  it "shoud get show" do
    get :show, id: task.id
    assigns(:task).should == task
    assigns(:comments).should == task.comments
    response.code.should eq("200")
  end

  it "should get new" do
    project = task.project
    get :new, project_id: project.id
    assigns(:project).should == project
    response.code.should eq("200")
  end

  it "should get edit" do
    get :edit, id: task.id
    assigns(:task).should == task
    response.code.should eq("200")
  end

  it "should change task status" do
    get :change_status, id: task.id, status_id: 2
    assigns(:task).status.name.should == 'Scheduled'
  end

  describe "POST create" do
    def do_action(attributes = {})
      post(:create, project_id: task.project, task: attributes)
    end

    context "valid attributes" do
      before(:each) do
        do_action( name: "Hidden Project", status_id: 1, type_id: 1 )
      end

      it { should assign_to(:task)}
      it { assigns(:task).user.should == subject.current_user }
      it { should redirect_to(task.project) }
      it { should set_the_flash.to("Task was successfully created.") }
    end

    context "invalid attributes" do
      before(:each) do
        do_action
      end

      it { should render_template(:new) }
    end
  end

  describe "PUT update" do
    def do_action(attributes = {})
      put(:update, id: task.id, task: attributes)
    end

    context "authenticated" do
      before(:each) do
        login!
      end

      context "valid attributes" do
        before(:each) do
          do_action( name: "New Project name", status_id: 2, type_id: 2 )
        end

        it { should assign_to(:task)}
        it { should redirect_to(assigns(:task)) }
        it { should set_the_flash.to("Task was successfully updated.") }
      end

      context "invalid attributes" do
        before(:each) do
          do_action(name: "")
        end

        it { should render_template(:edit) }
      end
    end
  end

  describe "GET destroy" do
    def do_action
      delete(:destroy, :id => task.id)
    end

    context "authenticated" do
      before(:each) do
        login!
      end

      it "should delete a task" do
        expect {
          do_action
        }.to change(Task, :count).by(-1)
      end

      it "should redirect to project url" do
        do_action
        should redirect_to(task.project)
      end
    end
  end

end

