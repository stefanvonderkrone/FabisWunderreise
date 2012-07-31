package fabis.wunderreise.core {

	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public class FabisLoader extends Sprite {
		
		private var _view : FabisLoaderView;
		private var _loader : XMLLoader;
		private var _resourcesURL : String = "resources.xml";

		public function FabisLoader() {
			if ( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}

		private function init( evt : Event = null ) : void {
			removeEventListener( Event.ADDED_TO_STAGE, init );
			LoaderMax.activate( [ SWFLoader, MP3Loader ] );
			_view = FabisLoaderView( addChild( new FabisLoaderView() ) );
			_view._bar.width = 0;
			if ( stage.loaderInfo.parameters.resourcesXML )
				_resourcesURL = stage.loaderInfo.parameters.resourcesXML;
			_loader = new XMLLoader( _resourcesURL, { onProgress: handleLoaderProgress, onComplete: handleLoaderComplete } );
			_loader.load();
		}
		
		private function handleLoaderProgress( evt : LoaderEvent ) : void {
			_view._bar.width = 400 * _loader.progress;
		}
		
		private function handleLoaderComplete( evt : LoaderEvent ) : void {
			removeChild( _view );
			addChild( LoaderMax.getContent( "FabisWunderreise" ) );
		}
	}
}
