module Authors
  class AccountsController < AuthorController

    def edit
      
    end
      
    def update_info
      if current_author.update(author_info_params)
        flash[:success] = 'successfully saved info.'
      else
        
        flash[:danger] = current_author.display_errors_message
      end
      redirect_to authors_account_path
    end
      
    def change_password
      author = current_author
      pass_info = author_password_params
      
      if author.valid_password?(pass_info[:current_password])
        if author.change_password(pass_info)
          sign_in(author, bypass: true)
          flash[:success] = 'Successfuly changed password.'
        else
          flash[:danger] = author.display_errors_message
        end
      else
        flash[:danger] = 'Current password was incorrect.'
      end
      
      redirect_to authors_account_path
    end
    
    private 
    
    def author_info_params
      params.require(:author).permit(:name, :email, :bio)
    end
    
    def author_password_params
      params.require(:author).permit(:current_password, :new_password, :new_password_confirmation)
    end
  end
end