# JumboProject

The requirement is to build a single-screen app to execute multiple "operations" defined in a javascript file, and display the progress and state of these operations to the user.
_______________________
## Design
<img src="/imgs/JS Operation Loading v2.png"  width="750" height="200"> 

#### ID Loader
- Responsible for generating a specifed number of opaque unique ID's
#### ProgressDisplayViewController
- Responsible for creating ResponseMessageViewModel and responding to its changes
### ResponseMessageViewModel
- Created with a specific opaque unique ID
- Conforms to JSOperationLoaderDelegate to receive updates
- Owns JSOperationLoader through JSOperationLoaderProtocol property
#### JSOperationLoader
- Responsible for loading the Javascript Operation
- Evaluating Javascript and executing startOperation(id)
- Passing response and errors to JSOperationLoaderDelegate
_______________________
## Challenges
A challenge I faced was coming up with a way to properly unit test the JSOperationLoader. My objective was to test the communication to the JSOperationLoaderDelegate. The current design is dependent on the WebKit framework and its methods are tied to WebKit delegate methods. Testing this class would lead to an integration test which is not my objective.
