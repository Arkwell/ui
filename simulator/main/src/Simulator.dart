//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Apr 23, 2012  2:45:26 PM
// Author: tomyeh

/**
 * The simulator.
 */
class Simulator extends Activity {
	Size _simSize;
	bool _horizontal;
	/** The dashboard. */
	Dashboard dashboard;
	/** The service for handling the communication between the simulator
	 * and the application.
	 */
	SimulatorService service;

	Simulator() {
		simulator = this;
		service = new SimulatorService();

		browser.size.width = window.innerWidth;
		browser.size.height = window.innerHeight;

		//Note: the app might run faster than the simulator,
		//so the initial size has to be the same as CSS in main.css
		_createDeviceLook();
		_setSimulatedSize(320, 480, false);
	}
	//@Override
	void onCreate_() {
		dashboard = new Dashboard();
		rootView.appendChild(dashboard);

		//TODO: load the default simulated size and invoke setSimulatedSize here
		_syncDashboardSize();

		window.on.resize.add((event) {
			_syncDashboardSize();
		});
	}
	//@Override
	void mount_() {
		//does nothing
	}

	/** Returns the simulated dimension of the device.
	 */
	Size get simulatedSize() => _simSize;
	/** Sets the orientation.
	 */
	void setOrient(bool horizontal) {
		setSimulatedSize(_simSize.height, _simSize.width, horizontal);
	}
	/** Sets the size and orientation.
	 */
	void setSimulatedSize(int width, int height, bool horizontal) {
		_setSimulatedSize(width, height, horizontal);
		_syncDashboardSize();

		simulatorQueue.send({'name': 'setSize', 'orient': horizontal});
	}
	/** Called when the Home button was clicked.
	 */
	void onHome() {
		print("Home is pressed"); //TODO
	}

	void _setSimulatedSize(int width, int height, bool horizontal) {
		_simSize = new Size(width, height);
		_horizontal = horizontal;

		CSSStyleDeclaration style = document.query("#v-main").style;
		style.width = StringUtil.px(width);
		style.height = StringUtil.px(height);

		Element simNode = document.query("#v-simulator");
 		if (_horizontal) {
			simNode.query(".v-top").style.height = "0";
			simNode.query(".v-bottom").style.height = "0";
			simNode.query(".v-left").style.width = "20px";

			style = simNode.query(".v-right").style;
			style.width = "60px";
			style.height = StringUtil.px(height ~/ 2  + 16); //position home at center

			simNode.query(".v-right .v-home").style.display = "";
			simNode.query(".v-bottom .v-home").style.display = "none";
		} else {
			simNode.query(".v-top").style.height = "20px";
			simNode.query(".v-bottom").style.height = "60px";
			simNode.query(".v-left").style.width = "0";
			simNode.query(".v-right").style.width = "0";

			simNode.query(".v-right .v-home").style.display = "none";
			simNode.query(".v-bottom .v-home").style.display = "";
		}
	}
	void _createDeviceLook() {
		final Element simNode = document.query("#v-simulator");
		simNode.insertAdjacentHTML("afterBegin",
			'<div class="v-top">rikulo</div><div class="v-left"></div>');
		simNode.insertAdjacentHTML("beforeEnd",
			'''
<div class="v-right"><div class="v-home" style="display:none"></div></div>
<div class="v-bottom"><div class="v-home"></div></div>
			''');
		simNode.insertAdjacentHTML("afterEnd", '<div id="v-dashboard"></div>');

		for (final Element node in document.queryAll("#v-simulator .v-home")) {
			node.on.click.add((event) {onHome();});
		}
	}
	void _syncDashboardSize() {
		int left = simulatedSize.width + (_horizontal ? 120: 40);
		Element dashNode = document.query("#v-dashboard");
		CSSStyleDeclaration style = dashNode.style;
		style.left = StringUtil.px(left);
		style.top = "0px";
		style.width = StringUtil.px(window.innerWidth - left);
		style.height = StringUtil.px(window.innerHeight);

		dashboard.width = rootView.width = new DomQuery(dashNode).innerWidth;
		dashboard.height = rootView.height = new DomQuery(dashNode).innerHeight;
		dashboard.requestLayout();
	}
}
Simulator simulator;

void main() {
	new Application(name: "Simulator", inSimulator: true);
	new Simulator().run(nodeId: "v-dashboard");
}