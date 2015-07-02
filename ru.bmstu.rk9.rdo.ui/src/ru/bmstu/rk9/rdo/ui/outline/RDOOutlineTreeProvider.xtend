package ru.bmstu.rk9.rdo.ui.outline

import org.eclipse.swt.graphics.Image

import org.eclipse.xtext.ui.editor.outline.impl.AbstractOutlineNode
import org.eclipse.xtext.ui.editor.outline.IOutlineNode

import ru.bmstu.rk9.rdo.rdo.ParameterType

import ru.bmstu.rk9.rdo.rdo.ResourceCreateStatement

import ru.bmstu.rk9.rdo.rdo.Sequence

import ru.bmstu.rk9.rdo.rdo.Function
import ru.bmstu.rk9.rdo.rdo.FunctionParameter

import ru.bmstu.rk9.rdo.rdo.Constant

import ru.bmstu.rk9.rdo.rdo.Pattern
import ru.bmstu.rk9.rdo.rdo.RelevantResource
import ru.bmstu.rk9.rdo.rdo.DecisionPointSearchActivity
import ru.bmstu.rk9.rdo.rdo.DecisionPointActivity

import ru.bmstu.rk9.rdo.rdo.Result
import ru.bmstu.rk9.rdo.rdo.DefaultMethod
import ru.bmstu.rk9.rdo.rdo.ResourceType
import ru.bmstu.rk9.rdo.rdo.Event

public class VirtualOutlineNode extends AbstractOutlineNode {
	protected new(IOutlineNode parent, Image image, Object text, boolean isLeaf) {
		super(parent, image, text, isLeaf)
	}
}

class RDOOutlineTreeProvider extends org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider {

	// Resource Types
	def _createChildren(IOutlineNode parentNode, ResourceType resourceType) {
		for (parameterType : resourceType.eAllContents.toIterable.filter(typeof(ParameterType))) {
			createNode(parentNode, parameterType)
		}
	}

	def _isLeaf(ParameterType parameterType) { true }

	// Resources
	def _isLeaf(ResourceCreateStatement resourceCreateStatement) { true }

	// Sequence
	def _isLeaf(Sequence sequence) { true }

	// Functions
	def _createChildren(IOutlineNode parentNode, Function function) {
		for (functionParameter : function.eAllContents.toIterable.filter(typeof(FunctionParameter))) {
			createNode(parentNode, functionParameter)
		}
	}

	def _isLeaf(FunctionParameter functionParameter) { true }

	// Constants
	def _isLeaf(Constant constant) { true }

	// Pattern
	def _createChildren(IOutlineNode parentNode, Pattern pattern) {
		if (!pattern.eAllContents.filter(typeof(ParameterType)).empty) {
			val groupParameters = new VirtualOutlineNode(parentNode, parentNode.image, "Parameters", false)
			for (parameterType : pattern.eAllContents.toIterable.filter(typeof(ParameterType))) {
				createEObjectNode(groupParameters, parameterType)
			}
		}

		val groupRelevantResource = new VirtualOutlineNode(parentNode, parentNode.image, "Relevant resources", false)
		for (relevantResource : pattern.eAllContents.toIterable.filter(typeof(RelevantResource))) {
			createEObjectNode(groupRelevantResource, relevantResource)
		}
	}

	// Events
	def _isLeaf(Event event) { true }

	// Decision points
	def _isLeaf(DecisionPointSearchActivity decisionPointSearchActivity) { true }

	def _isLeaf(DecisionPointActivity decisionPointActivity) { true }

	// Results
	def _isLeaf(Result result) { true }

	// DefaultMethods
	def _isLeaf(DefaultMethod method) { true }
}
