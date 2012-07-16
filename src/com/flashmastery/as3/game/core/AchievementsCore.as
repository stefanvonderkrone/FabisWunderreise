package com.flashmastery.as3.game.core {
	import com.flashmastery.as3.game.interfaces.core.IAchievementsCore;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class AchievementsCore extends Object implements IAchievementsCore {
		
		protected var _created : Boolean;
		
		public function AchievementsCore() {
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				_created = true;
				handleCreation();
			}
		}

		protected function handleCreation() : void {
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
			}
		}

		protected function handleDisposal() : void {
		}
	}
}
