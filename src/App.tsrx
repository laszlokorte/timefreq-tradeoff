import { track } from 'ripple';
import favicon from './assets/favicon.svg'

function makeColor(x : number, y : number) : string {
  return  `rgb(${255-255*x},${255*y},${255/2})`
}

export component App() {
  const sizelog = 6
	const size = Math.pow(2, sizelog);
	const tex = 1024
	const img = 612

	const rects = Array(size*(sizelog+1)).fill(0).map((_,i) => {
		const rows = Math.pow(2, Math.floor(i/size))
		const cols = size / rows
		const x = (i % size) % rows / rows
		const y = Math.floor((i%size) / rows) / cols

		const height= 1 / cols
		const width= 1 / rows

		return {
			x: x * tex,
			y: y * tex,
			width: width * tex,
			height: height * tex,
			stroke: `#333`,
			fill: makeColor((y+height/2), (x+width/2))
		}
	})

	const wavelets = Array(size).fill(null).map((_,i) => {
		const f = Math.floor(Math.log2(i+1)) + 1
		const ff = i - Math.pow(2, f)

		return (f*size+i+1-size)
	})

	let &[r] = track(0)
	let &[w] = track(false)
	let &[b] = track(true)

	<head>

	<title>"foo"</title>
	<link rel="icon" href={favicon} / >
	</head>

	<main>

    <div class="plot">
      <div class="plot-titel">

        <h1>"Time/Frequency Trade-off"</h1>
        <div class="slider">

    		<label>
        <input checked={w} oninput={(evt : InputEvent) => w = (evt.currentTarget  as HTMLInputElement)?.checked ?? false} type="checkbox" /> " Mix"
        </label>
    		<label class={{hidden:w, "range-label": true}}>
        " &middot; "
    		"Trade-off:"
        <input disabled={w} value={r} oninput={(evt : InputEvent) => r = (evt.currentTarget  as HTMLInputElement)?.valueAsNumber ?? 0} type="range" min={0} max={sizelog} />
   			</label>
   			<output>
        {text r*size}"-"{text (r+1)*size}" / "{text rects.length}
      </output>

      <span  class={{hidden:w}}>
   			" &middot; "
      </span>
   			<label>
        <input checked={b} oninput={(evt : InputEvent) => b = (evt.currentTarget  as HTMLInputElement)?.checked ?? false} type="checkbox" />
        " Grid"
        </label>
        </div>
      </div>
      <div class={{"axis-x": true}}>"Time"</div>
      <div class="axis-y">"Frequency"</div>
      <div class={{"plot-body": true}}>

        <svg viewBox={`-5 -5 ${tex+10} ${tex+10}`} width={img} height={img}>
        <g transform={` translate(${0}, ${tex/2}) scale(1.0, -1.0) translate(${0}, ${-tex/2})`}>


  		<g>
  		for(const rect of rects.slice(r*size, (r+1)*size); index i; key i) {
  				<rect
  				class={{border:b}}
  					shape-rendering="crispEdges"
  					vector-effect="non-scaling-stroke"
  					{...rect}
  					stroke-width="1"></rect>
  		}
  			</g>

  			<g class="interactive">

  		for(const rect of rects.slice(r*size, (r+1)*size); index i; key i) {
  				<rect
  					shape-rendering="crispEdges"
  					vector-effect="non-scaling-stroke"
  					{...rect}
  					stroke="none"
  					fill="none"
  					class="selectable"
  					stroke-width="1"></rect>
  		}
  			</g>

  		<g class={{"wavelets": true, active: w}}>
  		for(const r of wavelets; index i; key i) {
  		const rect = rects[r%rects.length]
  				<rect
  				class={{border:b}}
  					shape-rendering="crispEdges"
  					vector-effect="non-scaling-stroke"
  					{...rect}
  					stroke-width="1"></rect>

  		}
  		</g>

  			<g class={{"wavelets": true, active: w,interactive:true}}>
  				for (const r of wavelets; index i; key i) {
  				const rect = rects[r%rects.length]
  							<rect
  					shape-rendering="crispEdges"
  					vector-effect="non-scaling-stroke"
  					{...rect}
  					stroke="none"
  					fill="none"
  					class="selectable"
  					stroke-width="1"></rect>

  		}
  		</g>
        </g>

        </svg>
      </div>
  </div>
</main>


	<style>
 :root {
                font-family: monospace;
                color-scheme: light dark;
            }
			:global(body) {
				font-family: monospace;
				font-size: 1em;
			}
			svg {
				display: block;
				border: 2px solid #aaa;
			}
			.slider {
				display: flex;
				align-items: center;
				gap: 1ex;
				padding: 1ex;
			}

			input {
				margin: 0;
				padding: 0;
				padding: 0;
			}

			.range-label {
			display: flex;
			flex-grow: 1;
			gap: 1ex;
			}

			input[type=range] {
			flex-grow: 1;
			}

			main {
				width: max-content;
				margin: auto;
				padding-bottom: 2em;
			}
			output {
				width: 10em;
				text-align: center;
			}

			h1 {
				text-align: center;
			}

			.wavelets {
				fill-opacity: 0;
				stroke-opacity: 0;
				pointer-events: none;
				transition: fill-opacity 0.2s 0.2s  linear, stroke-opacity 0.1s  linear;
			}
			.interactive {
				pointer-events: all;
			}
			.wavelets.interactive {
				pointer-events: none;
			}
			.wavelets.active {
				fill-opacity: 1;
				stroke-opacity: 1;
				transition: fill-opacity 0.3s linear, stroke-opacity 0.2s  0.2s linear;
			}
			.wavelets.interactive.active {
				pointer-events: all;
			}
			label {
				display: flex;
				gap: 1ex;
				align-items: center;
			}
			.hidden {
				opacity: 0.2
			}
			rect.selectable {
				fill: none;
				stroke: none;
				stroke-width: 3;
			}
			rect.selectable:hover {
				stroke: white;
			}
    rect {
			stroke-width: 0;
			}
    rect.border {
			stroke-width: 1
			}

    .plot {
      display: grid;
      gap: 1ex;
      grid-template-columns: [axis-y-start] auto [axis-y-end body-start axis-x-start titel-start] 1fr [titel-end axis-x-end body-end];
      grid-template-rows:[titel-start] auto [titel-end body-start axis-y-start] 1fr [body-end axis-y-end axis-x-start] auto [axis-x-end];
    }
    .plot-titel {
      grid-area: titel;
    }
    .plot-body {
      grid-area: body;
    }
    .axis-x {
      text-align: center;
      grid-area: axis-x;
      margin-top: 1em;
      translate: 0 -50%;
    }
    .axis-y {
      text-align: center;
      grid-area: axis-y;
      align-self: center;
      justify-self: center;
      translate: 50% 0;
      margin-right: 1em;
      rotate: -90deg;
    }
</style>
}
