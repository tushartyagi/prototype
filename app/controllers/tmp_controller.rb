class TmpController < ApplicationController
  def create_iteration
    @solution = current_user.solutions.find_by_uuid!(params[:solution_id])

    tempfile = Tempfile.new
    tempfile.write("A fake file that was created when you clicked the 'create fake iteration' button.")
    tempfile.rewind
    file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, type: 'text/plain')
    file.headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"fake-solution-created-with-button.txt\"\r\nContent-Type: application/octet-stream\r\n"

    CreatesIteration.create!(@solution, [file])
    redirect_to [:my, @solution]
  end

  def create_team_iteration
    @team = Team.find(params[:team_id])
    @solution = TeamSolution.find_by_uuid_for_team_and_user(params[:solution_id], @team, current_user)

    tempfile = Tempfile.new
    tempfile.write("A fake file that was created when you clicked the 'create fake iteration' button.")
    tempfile.rewind
    file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, type: 'text/plain')
    file.headers = "Content-Disposition: form-data; name=\"files[]\"; filename=\"fake-solution-created-with-button.txt\"\r\nContent-Type: application/octet-stream\r\n"

    CreatesIteration.create!(@solution, [file])
    redirect_to teams_team_my_solution_path(@team, @solution)
  end
end
