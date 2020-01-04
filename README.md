# JumboProject

The requirement is to build a single-screen app to execute multiple "operations" defined in a javascript file, and display the progress and state of these operations to the user.
_______________________
## Design
<img src="/imgs/JS Operation Loading Current.png"  width="650" height="200"> 

#### ID Loader
- Responsible for generating a specifed number of opaque unique ID's
#### ProgressDisplayViewController
- Conforms to the JSOperationLoaderDelegate Protocol which gives access to methods to update the ViewModel state
  - The TableViewCell will react to changes in the ViewModel class
#### JSOperationLoader
- Created with a specific opaque unique ID
- Responsible for loading the Javascript
- Evaluating Javascript and executing startOperation(id)
- Passing data to to JSOperationLoaderDelegate
_______________________
## Challenges

A challenge I faced was coming up with a way to properly unit test the JSOperationLoader. My objective was to test the communication to the JSOperationLoaderDelegate. The current design is dependent on the WebKit framework and its methods are tied to WebKit delegate methods. Testing this class would lead to an integration test which is not my objective.

#### Possible Improvements
<img src="/imgs/JS Operation Loading Proposed.png"  width="650" height="230"> 
The methods within the JSOperationLoader can be derived from a Protocol JSOperationLoaderProtocol. This would allow me to test the behavior of the JSOperationLoader independent of WebKit (Testing behavior rather than implementation).

