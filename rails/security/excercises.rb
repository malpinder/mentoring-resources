

# Assuming:

#  - `params` is a hash of arbitrary user-supplied data
#  - a loan belongs to a business
#  - this code is all in a Rails 4 app
#  - everything not explicitly defined either doesn't matter or does what it says it does

# describe the vulnerabilities in the following methods, and for bonus points, how you could exploit them:

###############################
# (in routes.rb)

get 'loans/:id' => 'loans#show', as: :loan
get 'loans/:id/edit' => 'loans#edit', as: :edit_loan
get 'loans/:id/update' => 'loans#update'

# (in a controller)
def update
  redirect_to(login_path) and return unless user_signed_in?
  loan = Loan.find(params[:loan_id])
  if loan.update(loan_params)
    redirect_to loan_path(params[:loan_id])
  else
    render :edit, notice: "Failed to save"
  end
end

def loan_params
  params.require(:loan).permit(:amount, :description)
end

################################

# (in routes.rb)
resources :bids
resources :comments
get "pages/new" => "admin/pages#new"
post "pages" => "admin/pages#create"

get '*path' => 'legacy#redirect'

# (in LegacyController)
def redirect
  if params[:page_slug]
    page = Page.find_by_slug(params[:page_slug])
    redirect_to "#{page.url}?legacy=true"
  else
    new_controller = LegacyConverter.for(params[:controller])
    redirect_to params.merge(controller: new_controller), only_path: true
  end
end

##############################

# (in lib/csv_mangler/upload.rb)
module CsvMangler
  class Upload

    def save(filename, uploaded_data)
      if has_acceptable_extension?(filename)
        safe_name = sanitized_filename(filename)

        Dir.mkdir("tmp/csv_uploads")
        location = File.join("tmp/csv_uploads", safe_name)

        File.write(location, uploaded_data)
      end
    end

    def sanitized_filename(filename)
      filename.gsub("../", '')
    end

    def has_acceptable_extension?(filename)
      filename =~ /\.csv|\.tsv\z/
    end
  end
end
