package fabis.wunderreise.sound {

	import com.flashmastery.as3.game.interfaces.delegates.IGameDelegate;

	/**
	 * @author Stefan von der Krone (2012)
	 */
	public interface IFabisLipSyncherDelegate extends IGameDelegate {
		
		function reactOnCumulatedSpectrum( cumulatedSpectrum : Number ) : void;
		
	}
}
