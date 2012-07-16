package com.flashmastery.as3.game.core.loading {

	import com.flashmastery.as3.game.interfaces.delegates.ILoaderCoreDelegate;
	import com.flashmastery.as3.game.interfaces.loading.ILoaderCore;
	import com.flashmastery.as3.game.interfaces.loading.ILoaderItem;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.data.LoaderMaxVars;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class LoaderCore extends Object implements ILoaderCore {
		
		private static const NAME : String = "LoaderMax";
		private static var _index : int = 0;
		
		protected var _loaderMax : LoaderMax;
		protected var _delegates : Vector.<ILoaderCoreDelegate>;
		protected var _loaders : Vector.<LoaderItem>;
		protected var _loaderItems : Vector.<ILoaderItem>;
		protected var _isLoading : Boolean;
		protected var _created : Boolean;
		
		public function LoaderCore() {
			create();
		}

		final public function create() : void {
			if ( !_created ) {
				const vars : LoaderMaxVars = new LoaderMaxVars();
				vars.name( NAME + ( _index++ ).toString() );
				vars.onChildComplete( handleItemComplete );
				vars.onChildFail( handleItemError );
				vars.onComplete( handleComplete );
				vars.onError( handleError );
				vars.onFail( handleError );
				vars.onIOError( handleError );
				vars.onProgress( handleProgress );
				_loaderMax = new LoaderMax( vars );
				_delegates = new Vector.<ILoaderCoreDelegate>();
				_loaders = new Vector.<LoaderItem>();
				_loaderItems = new Vector.<ILoaderItem>();
				_created = true;
				handleCreation();
			}
		}

		final public function dispose() : void {
			if ( _created ) {
				handleDisposal();
				_created = false;
			}
		}

		protected function handleDisposal() : void {
		}

		protected function handleCreation() : void {
		}

		protected function handleProgress( evt : LoaderEvent ) : void {
			
		}

		protected function handleError( evt : LoaderEvent ) : void {
			
		}

		protected function handleComplete( evt : LoaderEvent ) : void {
			
		}

		protected function handleItemError( evt : LoaderEvent ) : void {
			
		}

		protected function handleItemComplete( evt : LoaderEvent ) : void {
			
		}

		public function loadItem(item : ILoaderItem) : void {
			const index : int = _loaderItems.indexOf( item );
			if ( index < 0 ) {
				var loader : LoaderItem;
				switch( item.type ) {
					case GameLoaderItemType.DATA:
						loader = new DataLoader( item.url, item.options );
						break;
					case GameLoaderItemType.IMAGE:
						loader = new ImageLoader( item.url, item.options );
						break;
					case GameLoaderItemType.SWF:
						loader = new SWFLoader( item.url, item.options );
						break;
					case GameLoaderItemType.XML:
						loader = new XMLLoader( item.url, item.options );
						break;
					case GameLoaderItemType.VIDEO:
						loader = new VideoLoader( item.url, item.options );
						break;
					case GameLoaderItemType.MP3:
						loader = new MP3Loader( item.url, item.options );
						break;
					case GameLoaderItemType.CSS:
						loader = new CSSLoader( item.url, item.options );
						break;
				}
				if ( loader != null ) {
					_loaderItems.push( item );
					_loaders.push( loader );
					_loaderMax.append( loader );
					if ( !_isLoading ) {
						_isLoading = true;
						_loaderMax.load();
					}
				}
			}
		}

		public function loadItems(items : Vector.<ILoaderItem>) : void {
			var index : int = items.length;
			while ( --index >= 0 )
				loadItem( items[ index ] );
		}

		public function addDelegate(delegate : ILoaderCoreDelegate) : void {
			const index : int = _delegates.indexOf( delegate );
			if ( index < 0 )
				_delegates.push( delegate );
		}

		public function removeDelegate(delegate : ILoaderCoreDelegate) : void {
			const index : int = _delegates.indexOf( delegate );
			if ( index >= 0 )
				_delegates.splice( index, 1 );
		}

		public function start() : void {
		}

		public function stop() : void {
		}
	}
}
