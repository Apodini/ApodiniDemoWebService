import Apodini
import ApodiniOpenAPI
import ApodiniREST
import ArgumentParser
import ApodiniDeploy
import DeploymentTargetIoTRuntime
import LifxIoTDeploymentOption

@main
struct TestWebService: WebService {
    var content: some Component {
        Group("demo") {
            Text("Test")
                .identified(by: "Handler1")
                .metadata(
                    DeploymentDevice(.lifx)
                )
            Group("123") {
                TextHandler("Spain")
            }
        }
        Group("exe") {
            Text("Should be visible")
                .metadata(
                    DeploymentDevice(.lifx)
                )
            Text("Should not be visible")
                .operation(.delete)
        }
    }
    
    var configuration: Configuration {
        REST {
            OpenAPI()
        }
        ApodiniDeploy(runtimes: [IoTRuntime<Self>.self])
    }
}
