package fabis.wunderreise.games.memory {
	import com.junkbyte.console.Cc;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisMemoryGameCard extends Sprite {

		protected var _card : DisplayObject;
		protected var _cover : DisplayObject;
		protected var _id : int;
		protected var _container : Sprite;
		protected var _width : Number = 100;
		protected var _height : Number = 100;

		public function FabisMemoryGameCard() {
			_container = Sprite( addChild( new Sprite() ) );
		}
		
		public function setSize( width : Number, height : Number ) : void {
			_width = width;
			_height = height;
			if ( _card ) {
				_card.width = _width;
				_card.height = _height;
				_card.x = -( _width >> 1 );
				_card.y = ( _height >> 1 );
				_card.scaleY = -1;
			}
			if ( _cover ) {
				_cover.width = _width;
				_cover.height = _height;
				_cover.x = -( _width >> 1 );
				_cover.y = -( _height >> 1 );
			}
		}

		public function get card() : DisplayObject {
			return _card;
		}

		public function set card( card : DisplayObject ) : void {
			if ( _card && _card != card )
				_container.removeChild( _card );
			_card = card;
			_container.addChildAt( _card, 0 );
			_card.width = _width;
			_card.height = _height;
			_card.x = -( _width >> 1 );
			_card.y = ( _height >> 1 );
			_card.scaleY = -1;
			if ( _card && _cover )
				update();
		}

		public function get cover() : DisplayObject {
			return _cover;
		}

		public function set cover( cover : DisplayObject ) : void {
			if ( _cover && _cover != cover )
				_container.removeChild( _cover );
			_cover = cover;
			_container.addChild( _cover );
			_cover.width = _width;
			_cover.height = _height;
			_cover.x = -( _width >> 1 );
			_cover.y = -( _height >> 1 );
			if ( _card && _cover )
				update();
		}

		final public function showCover( duration : Number ) : void {
			TweenLite.to( _container, duration, { scaleY: -1, onUpdate: update } );
		}

		final public function hideCover( duration : Number ) : void {
			TweenLite.to( _container, duration, { scaleY: 1, onUpdate: update } );
		}

		final public function highlight( duration : Number ) : void {
			TweenMax.to( _container, duration, { colorTransform: { brightness: 1.5 } } );
		}

		final public function dehighlight( duration : Number ) : void {
			TweenMax.to( _container, duration, { colorTransform: { brightness: 1 } } );
		}

		protected function update() : void {
			if ( _container.scaleY < 0 ) {
				_cover.visible = false;
				_card.visible = true;
			} else if ( _container.scaleY >= 0 ) {
				_cover.visible = true;
				_card.visible = false;
			}
		}

		public function get id() : int {
			return _id;
		}

		public function set id( id : int ) : void {
			_id = id;
		}
		
		public function addClickHandler() : void {
			this.buttonMode = true;
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
	}
}
