# JumboProject

The requirement is to build a single-screen app to execute multiple "operations" defined in a javascript file, and display the progress and state of these operations to the user.
_______________________
## Design
<img src="/imgs/JS Operation Loading v4.png"  width="750" height="250"> 

#### ID Loader
- Responsible for generating a specifed number of opaque unique ID's
#### ProgressDisplayViewController
- Renders the view
- Respond to updates from ProgressDisplayLogicController
#### ProgressDisplayLogicController
- Creates ResponseMessageViewModels 
- Owns JSOperationLoader through JSOperationLoaderProtocol property
- Conforms to JSOperationLoaderDelegate to receive updates
- Send updates to ProgressDisplayViewController
#### ResponseMessageViewModel
- Created with a specific opaque unique ID
#### JSOperationLoader
- Responsible for loading the Javascript Operation
- Evaluating Javascript and executing startOperation(id)
- Passing response and errors to JSOperationLoaderDelegate
_______________________
## Challenges
A challenge I faced was coming up with a way to properly unit test the JSOperationLoader in isolation from WebKit. 
