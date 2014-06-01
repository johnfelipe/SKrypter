.pragma library

/**
 * This function creates a model including dummy nodes that are needed to
 * display the fields correctly!
 *
 * @param  model The base model
 * @param  modelWithDummies the model with dummy nodes
 * @param  neededDummies indicates how many dummies need to be in the modelWithDummies
 * @return  the model with dummy nodes
 */
function getModelWithDummies(model, modelWithDummies, neededDummies) {
    modelWithDummies.clear()

    for (var i=0; i<model.length; i++) {
        modelWithDummies.append(model[i])
    }

    var dummyElement = {"picture":"", "title": "Dummy"}
    for (var i=0; i<neededDummies; i++) {
        modelWithDummies.append(dummyElement)
    }

    return modelWithDummies
}
