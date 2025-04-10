// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import NestedFormController from "./nested_form_controller"
application.register("nested-form", NestedFormController)

import TomSelectController from "./tom_select_controller"
application.register("tom-select", TomSelectController)

import RemoveCollaboratorController from "./remove_collaborator_controller"
application.register("remove-collaborator", RemoveCollaboratorController)
