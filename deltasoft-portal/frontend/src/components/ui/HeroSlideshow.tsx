import { useEffect, useState } from "react";
import styles from "./HeroSlideshow.module.css";

export function HeroSlideshow({ images, intervalMs = 5000 }: { images: string[]; intervalMs?: number }) {
  const [index, setIndex] = useState(0);

  useEffect(() => {
    if (images.length <= 1) return;
    const timer = setInterval(() => {
      setIndex((i) => (i + 1) % images.length);
    }, intervalMs);
    return () => clearInterval(timer);
  }, [images.length, intervalMs]);

  return (
    <div className={styles.slideshow} aria-hidden="true">
      {images.map((src, i) => (
        <div
          key={src}
          className={`${styles.slide} ${i === index ? styles.active : ""}`}
          style={{ backgroundImage: `url(${src})` }}
        />
      ))}
      <div className={styles.overlay} />

      {images.length > 1 && (
        <div className={styles.dots}>
          {images.map((src, i) => (
            <button
              key={src}
              type="button"
              className={`${styles.dot} ${i === index ? styles.dotActive : ""}`}
              aria-label={`Image ${i + 1}`}
              onClick={() => setIndex(i)}
            />
          ))}
        </div>
      )}
    </div>
  );
}
