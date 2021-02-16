<p align="center">
  <img src="http://svrless.org/img/svrless-logo.svg" width="400">
</p>

# SVRLESS

Stop writing AWS Cloud Formation templates and start writing code!

SVRLESS is a framework built from scratch for Rails developers who want to dip their toe in the serverless world.
Writing configuration isn't everyone's cup of tea so lets fix that.

The 5 pillars of SVRLESS are:
- Remove the need to write Cloud Formation templates
- Be opinionated in how you structure your serverless project
- Feel like home to Ruby & Rails developers
- Get your project up and running on AWS fast
- Be open to everyone who wants to help or contribute code

## Prerequisite

AWS SAM CLI is required to build and deploy the `template.yaml` generated by this framework.

[Click here for instructions on installing SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html).

## Getting Started

1. Install the SVRLESS gem


        $ gem install 'svrless'

2. Create a new SVRLESS project


        $ svrless new your-project 

3. Change directory to your project


        $ cd your-project

4. Open `config/routes.rb` and uncomment the resources line

    ```ruby
    resources :post, :comment
    ```

5. Build your project


        $ svrless build


    Notice the newly created `app/functions/posts/controller.rb` and SAM ready `template.yaml`


        $ sam build

6. Start the local SAM server 
        

        $ sam local start-api

   Issue a `POST` request to `http://localhost:3000/posts` to see your lambda spring into action.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
